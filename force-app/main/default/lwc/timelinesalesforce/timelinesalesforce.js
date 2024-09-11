import { LightningElement, api, track, wire } from 'lwc';
import getClasses from '@salesforce/apex/ClassService.getClasses';
import checkPassword from '@salesforce/apex/PasswordValidator.checkPassword';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import VIS_TIMELINEJS from '@salesforce/resourceUrl/VisTimelineJS';
import VIS_TIMELINECSS from '@salesforce/resourceUrl/VisTimelineCSS';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getFieldValue } from 'lightning/uiRecordApi';
import { getSObjectValue } from '@salesforce/apex';

import NAMEFIELD from '@salesforce/schema/BeCode_Class__c.BeCode_Main_Coach__r.Name';
import CLASSFIELD from '@salesforce/schema/BeCode_Class__c.BeCode_Training__r.Name';
import SUPPORTFIELD from '@salesforce/schema/BeCode_Class__c.BeCode_Support_Coach__r.Name';

export default class ClassTimeline extends LightningElement {
    @track inputPassword = '';
    @track isAuthenticated = false;
    @track errorMessage = '';
    @track groups = [];
    @track items = null;
    visjsInitialized = false;
    timeline = null;
    @track preparedclasses = [];
    itemsCollection = [];
    @track data = [];
    @wire(getClasses)
    wiredClasses({ error, data }) {
        this.data = data;
        if(this.data) {
            this.classes = data;
            this.classes.forEach(classe => {
                let preparedClass = {};
                preparedClass.Id = classe.Id;
                preparedClass.name = classe.Name;
                preparedClass.start = classe.BeCode_Start_Date__c;
                preparedClass.end = classe.BeCode_End_Date__c;
                preparedClass.group = classe.BeCode_Campus__c + classe.Name.split('-').pop()
                preparedClass.coach = getSObjectValue(classe, NAMEFIELD);
                preparedClass.supportcoach = getSObjectValue(classe, SUPPORTFIELD);
                preparedClass.training = getSObjectValue(classe, CLASSFIELD);
                preparedClass.regstart = classe.registration_start_date__c;
                preparedClass.regend = classe.registration_end_date__c;
                preparedClass.campus = classe.BeCode_Campus__c;
                //console.log(getSObjectValue(classe, NAMEFIELD));
                //console.log(classe);

                this.preparedclasses.push(preparedClass);
            })
            this.itemsCollection = this.classes.map(cls => {
                return {
                    id: cls.Id,
                    content: cls.Name,
                    start: cls.BeCode_Start_Date__c,
                    end: cls.BeCode_End_Date__c,
                    group: `${cls.BeCode_Campus__c}-${cls.Name.split('-').pop()}`
                    //maincoach: cls.BeCode_Main_Coach__r ? cls.BeCode_Main_Coach__r.Name : "",
                    //supportcoach: cls.BeCode_Support_Coach__r ? cls.BeCode_Support_Coach__r.Name : "",
                    //training: cls.BeCode_Training__r ? cls.BeCode_Training__r.Name : ""
                };
            });
            if (this.visjsInitialized) {
                console.log("timeline loaded");
                this.initializeTimeline();
            }
        } else if (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error loading classes',
                message: error,
                variant: 'error',
            }));
            console.error('Error fetching classes:', error);
        }
    }
    
    renderedCallback() {
        if (this.visjsInitialized || !this.isAuthenticated) {
            return;
        }
        Promise.all([
            loadScript(this, VIS_TIMELINEJS),
            loadStyle(this, VIS_TIMELINECSS)
        ])
        .then(() => {
            if (this.isAuthenticated && this.classes) {
                this.initializeTimeline();
            }
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error loading VisJS',
                    message: error.message,
                    variant: 'error',
                }),
            );
            console.error('Error loading scripts/styles:', error);
        });
    }
    
    initializeTimeline() {
        const container = this.template.querySelector(".container");

        // Extract unique campus names for grouping
        const uniqueCampuses = [...new Set(this.classes.map(cls => cls.BeCode_Campus__c))];
    
        // Create campus groups and prepare to track nested class groups
        this.groups = uniqueCampuses.map(campus => {
            return {
                id: campus,
                content: campus,
                nestedGroups: [] // Prepare to hold nested class groups
            };
        });
        
        // Create a map for campus groups for easy access
        let campusGroupMap = {};
        this.groups.forEach(group => campusGroupMap[group.id] = group);
    
        // Process classes to create nested class groups within campuses
        const itemsCollection = this.preparedclasses.map(cls => {
            // Define the title here where 'cls' is in scope
            let title = `<strong>Class name:</strong> ${cls.name}<br>`;
            title = title + `<strong>Main Coach:</strong> ${cls.coach}<br>`;
            title = title + `<strong>Support Coach:</strong> ${cls.supportcoach}<br>`;
            title = title + `<strong>Training type:</strong> ${cls.training}<br>`;
            title = title + `<strong>Registration start:</strong> ${cls.regstart}<br>`;
            title = title + `<strong>Registration end:</strong> ${cls.regend}<br>`;
            title = title + `<strong>Training start:</strong> ${cls.start}<br>`;
            title = title + `<strong>Training end:</strong> ${cls.end}<br>`;
            
            const classShortName = cls.name.split('-').pop(); // Extracting class short name
            const classGroupKey = `${cls.campus}-${classShortName}`;
    
            // If this class group doesn't exist, create it and nest it within the campus
            if (!campusGroupMap[cls.campus].nestedGroups.includes(classGroupKey)) {
                this.groups.push({
                    id: classGroupKey,
                    content: classShortName,
                    // This group is nested within the campus group
                    treeLevel: 1 
                });
                campusGroupMap[cls.campus].nestedGroups.push(classGroupKey);
            }
    
            return {
                id: cls.Id,
                content: cls.name,
                start: cls.start,
                end: cls.end,
                group: classGroupKey,
                title: title // Tooltip content
            };
        });
    
        // Timeline options similar to the old timeline
        const currentDate = new Date();
        const sixMonthsAgo = new Date(currentDate.getFullYear(), currentDate.getMonth() - 6, currentDate.getDate());
        const oneYearLater = new Date(currentDate.getFullYear(), currentDate.getMonth() + 12, currentDate.getDate());
    
        const options = {
            stackSubgroups: true,
            showCurrentTime: true,
            stack: true,
            min: new Date(2017, 0, 1),
            start: sixMonthsAgo,
            end: oneYearLater,
            align: 'left',
            orientation: { axis: "both", item: "top" },
            autoResize: true,
            horizontalScroll: true,
            //verticalScroll: true,
            //zoomKey: "ctrlKey",
            groupOrder: 'content',
            showTooltips: true,
            width: '100%',
            margin: { item: 10 },
            zoomable: false,
            loadingScreenTemplate: function () {
                return "<h1 class='loading'>Loading...</h1>";
            }
        };

        this.items = new vis.DataSet(itemsCollection);
        this.timeline = new vis.Timeline(container, this.items, this.groups, options);
        this.timeline.on('rangechange', this.handleRangeChange.bind(this));
    }  

    handleRangeChange(properties) {
        const visibleStart = properties.start;
        const visibleEnd = properties.end;
        //console.log(document.getElementsByClassName("vis-vertical-scroll"));
        //const scrollTop = document.getElementsByClassName("vis-vertical-scroll")[0].scrollTop;
        
        // Filter items based on the visible time range
        const filteredItems = this.items.get({
            filter: function (item) {
                let itemStart = new Date(item.start);
                let itemEnd = new Date(item.end);
                return (itemStart >= visibleStart && itemStart <= visibleEnd) ||
                       (itemEnd >= visibleStart && itemEnd <= visibleEnd) ||
                       (itemStart < visibleStart && itemEnd > visibleEnd);
            }
        });
    
        // Extract unique campus names for grouping from the filtered items
        const uniqueCampuses = [...new Set(filteredItems.map(item => {
            let parts = item.group.split('-');
            return parts[0]; // Assuming the campus part of the id is before the first '-'
        }))];
    
        // Create campus groups and prepare to track nested class groups
        let filteredGroups = uniqueCampuses.map(campus => {
            return {
                id: campus,
                content: campus,
                nestedGroups: [] // Prepare to hold nested class groups
            };
        });
    
        // Create a map for campus groups for easy access
        let campusGroupMap = {};
        filteredGroups.forEach(group => campusGroupMap[group.id] = group);
    
        // Process filtered classes to create nested class groups within campuses
        filteredItems.forEach(item => {
            const classGroupKey = item.group;
            const classShortName = classGroupKey.split('-').pop(); // Extracting class short name
        
            // If this class group doesn't exist, create it and nest it within the campus
            if (!campusGroupMap[classGroupKey.split('-')[0]].nestedGroups.includes(classGroupKey)) {
                filteredGroups.push({
                    id: classGroupKey,
                    content: classShortName,
                    treeLevel: 1 // This group is nested within the campus group
                });
                campusGroupMap[classGroupKey.split('-')[0]].nestedGroups.push(classGroupKey);
            }
        });
    
        try {
            // Update the timeline with the filtered items and groups
            this.timeline.setGroups(new vis.DataSet(filteredGroups));
            this.timeline.setItems(new vis.DataSet(filteredItems));
            //window.scrollBy(scrollTop, 0);
            //setTimeout(() => {
            //    document.getElementsByClassName("vis-vertical-scroll")[0].scrollTop = scrollTop ;
            //}, 0);
            //console.log(document.documentElement.scrollTop);
        } catch (error) {
            console.error('Error updating timeline:', error);
        }
    }    
    
    handlePasswordChange(event) {
        this.inputPassword = event.target.value;
    }

    validatePassword() {
        checkPassword({ inputPassword: this.inputPassword })
            .then(result => {
                this.isAuthenticated = result;
                if (!result) {
                    this.errorMessage = 'Incorrect password';
                } else {
                    this.errorMessage = '';
                    // Initialize the timeline only if the scripts/styles are already loaded
                    if (this.classes && !this.visjsInitialized) {
                        this.initializeTimeline();
                    }
                }
            })
            .catch(error => {
                this.errorMessage = 'Error validating password';
                console.error('Error:', error);
            });
    }
    
    handleKeyUp(event) {
        if (event.keyCode === 13) { // 13 is the Enter key
            this.validatePassword();
        }
    }
    
}
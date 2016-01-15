$(document).ready(function() {
    'use strict';

    function OnePunchModel() {
        var self = this;

        function Image(imageSrc) {
            this.imageSrc = imageSrc;
        }

        function ImageList(field) {
            return function(data) {
                return field($.map(data, function(imageSrc) {
                    return new Image(imageSrc);
                }));
            };
        }

        this.searchKeywords = ko.observable();
        this.searchResults = ko.observable();
        ko.computed(function() {
            $.ajax({
                url: "/search",
                data: {
                    words: self.searchKeywords()
                },
                success: new ImageList(self.searchResults)
            });
        });

        this.randomImage = ko.observable();
        this.getRandomImage = function() {
            $.ajax({
                url: "/random",
                success: function(data) {
                    self.randomImage(data[0]);
                }
            });
        };

        this.images = ko.observable();
        this.showAllImages = function() {
            $.ajax({
                url: "/all",
                success: new ImageList(self.images)
            });
        };
    }

    ko.applyBindings(new OnePunchModel());
});

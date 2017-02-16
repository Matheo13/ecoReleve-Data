//Not used for now

define([
  'jquery',
  'backbone',
  'backbone-forms'

], function (
  $, Backbone, Form
) {
  'use strict';
<<<<<<< HEAD

  return Form.editors.Number = Form.editors.Number.extend({
    defaultValue: '',

    // var lat = /^\-?([1-8]?[0-9]|[1-9]0)(\.[0-9]{0,6})?$/.test(newVal);
    // long = /^\-?([1]?[1-7][1-9]|[1]?[1-8][0]|[1-9]?[0-9])(\.[0-9]{0,6})?$/.test(newVal);
    initialize: function (options) {
      Form.editors.Number.prototype.initialize.call(this, options);
      // this.options = options.schema.options;
    }
    // onKeyPress: function(event) {
    //   var self = this,
    //       delayedDetermineChange = function() {
    //         setTimeout(function() {
    //           self.determineChange();
    //         }, 0);
    //       };

    //   //Allow backspace
    //   if (event.charCode === 0) {
    //     delayedDetermineChange();
    //     return;
    //   }


    //   //Get the whole new value so that we can prevent things like double decimals points etc.
    //   var newVal = this.$el.val()
    //   if( event.charCode != undefined ) {
    //     newVal = newVal + String.fromCharCode(event.charCode);
    //   }
=======
  Form.editors.Number.prototype.initialize = function(options) {
      Form.editors.Text.prototype.initialize.call(this, options);

      var schema = this.schema;

      this.$el.attr('type', 'number');
>>>>>>> 9a374cebdfe412214dd03117f3f4b2754c32f4b8

      if (!schema || !schema.editorAttrs || !schema.editorAttrs.step) {
        // provide a default for `step` attr,
        // but don't overwrite if already specified
        this.$el.attr('step', 'any');
      }
    };

    return Form.editors.Number;
});

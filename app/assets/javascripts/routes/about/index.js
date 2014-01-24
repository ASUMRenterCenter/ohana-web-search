require(['app/loading-manager',
				 'app/feedback-form-manager',
				 'addEventListener',
				 'classList',
				 'domReady!'],
	function(lm,feedback) {
  'use strict';

	document.body.classList.add("require-loaded");
  lm.hide();
  feedback.init();

});
var exec = require('cordova/exec');

exports.user = function (success, error) {
    exec(success, error, 'lebang', 'user', []);
};

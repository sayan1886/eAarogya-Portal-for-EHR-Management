var mongoose = require("mongoose");
var passportLocalMongoose = require("passport-local-mongoose");

var UserSchema = new mongoose.Schema({
    _id: String,
    username: String,
    name: String,
    password: String,
    email: String,
    phone: String,
    ethereumAddress: String,
    privateKey: String,
    type: String,
    org: String,
    permission: [{
        type: String,
        ref: 'User'
    }]
});

UserSchema.plugin(passportLocalMongoose);

module.exports = mongoose.model("User", UserSchema);
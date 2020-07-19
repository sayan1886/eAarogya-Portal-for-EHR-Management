const express = require('express');
const router = express.Router();
const passport = require('passport');
const request = require('request');
const ehrClinician = require('../../FabricHelper/FabricHelperClinician');
const AadhaarUser = require('../../models/aadhaaruser');
let app = express();

//All routes have prefix /user/register-user
router.get('/', (req, res) => {
  res.render('user/register-user/index');
});

router.post('/', (req, res) => {
  let aadhaarNum = req.body.aadhaarNum.trim().replace(/[ -]/g, '');
  AadhaarUser.findOne({
    aadhaarNo: aadhaarNum
  }, (err, user) => {
    if (user) {
      app.set('details', user.toJSON());

      var options = {
        method: 'GET',
        url: 'http://2factor.in/API/V1/e84b3273-63bb-11ea-9fa5-0200cd936042/SMS/' + user.phoneNumber + '/AUTOGEN',
        headers: {
          'content-type': 'application/x-www-form-urlencoded'
        },
        form: {}
      };

      request(options, function (error, response, body) {
        if (error) throw new Error(error);

        let session = JSON.parse(body);
        app.set('sessionNum', session.Details);
      });

      res.render('user/register-user/enter-code', {
        error: null
      });
    } else {
      res.render('user/register-user/index');
    }
  })
});


router.post('/verify-otp', (req, res) => {
  let otp = req.body.code;
  let sessNum = app.get('sessionNum');
  let options = {
    method: 'GET',
    url: 'http://2factor.in/API/V1/e84b3273-63bb-11ea-9fa5-0200cd936042/SMS/VERIFY/' + sessNum + '/' + otp,
    headers: {
      'content-type': 'application/x-www-form-urlencoded'
    },
    form: {}
  };

  request(options, function (error, response, body) {
    if (error) throw new Error(error);

    if (response.statusCode == 200) {
      let details = app.get('details');
      res.render('user/register-user/complete-form', {
        details: details
      });
    } else {
      res.render('user/register-user/enter-code', {
        error: 'Invalid OTP'
      })
    }
  });
})

router.post('/complete-form', (req, res) => {
  let details = req.body;
  ehrClinician.createRecord(req, res, details);
  ehrClinician.createMedicineRecord(req, res, details);
  User.register(new User({
    username: req.body.username,
    email: req.body.email,
    phone: req.body.phone,
    type: 'user'
  }), req.body.password, (err, user) => {
    if (err) {
      console.log(err);
    } else {
      passport.authenticate('local')(req, res, () => {
        res.redirect('/');
      })
    }
  });
});

module.exports = router;
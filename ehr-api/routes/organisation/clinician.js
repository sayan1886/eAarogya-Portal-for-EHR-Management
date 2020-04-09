//Clinician Routes
const express = require('express');
const router = express.Router();
const passport = require('passport');
const ehrClinician = require('../../FabricHelper/FabricHelperClinician');
const User = require("../models/user");

//All routes have prefix '/organsation/clinician'
router.get('/login', function(req, res) {
    res.render('clinicianlogin');
});

router.post('/login', passport.authenticate('local', {
    successRedirect: '/',
    failureRedirect: '/login'
}), function(req, res) {});

router.get('/', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});


router.get('/medicalID', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});

router.post('/medicalID', function(req, res) {
    let MedicalID = req.body.medicalID;
    let doc = {
        'medicalID': MedicalID
    }
    User.findOne({ username: 'cliniciantest' }, function(err, found) {
        found.permission.forEach(function(perm) {
            if (perm == MedicalID) {
                ehrClinician.getReport(req, res, doc);
            } else {
                console.log('Not allowed')
            }
        });
    });


});


router.get('/addreport', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
})

router.post('/addreport', function(req, res) {
    let MedicalID = req.body.medicalID;
    let allergies = req.body.allergies;
    let symptoms = req.body.symptoms;
    let diagnosis = req.body.diagnoses
    let report = 'Allergies: ' + allergies + ', Symptoms: ' + symptoms + ', Diagnosis: ' + diagnosis;
    let doc = {
        'medicalID': MedicalID,
        'report': report
    }

    ehrClinician.addReport(req, res, doc);
    console.log(MedicalID);

});

router.get('/addprescription', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});

router.post('/addprescription', function(req, res) {
    let medicalID = req.body.medicalID;
    let medicalRecordID = medicalID + '0M';
    let prescription = req.body.prescription;
    let doc = {
        'medicalID': medicalRecordID,
        'prescription': prescription
    }
    ehrClinician.addMedicineReport(req, res, doc);
});

router.get('/getreport', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});

router.post('/getreport', function(req, res) {
    let medicalID = req.body.medicalID;
    let doc = {
        'medicalID': medicalID
    };
    ehrClinician.getReport(req, res, doc);
});

router.get('/getprescription', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});
router.post('/getprescription', function(req, res) {
    let medicalID = req.body.medicalID;
    let medicineID = medicalID + '0M';
    let doc = {
        'medicalID': medicineID
    }
    ehrClinician.getMedicineReport(req, res, doc);
});

router.get('/reporthistory', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});

router.post('/reporthistory', function(req, res) {
    let medicalID = req.body.medicalID;
    let doc = {
        'medicalID': medicalID
    }
    ehrClinician.getRecord(req, res, doc);
});

router.get('/medicinehistory', function(req, res) {
    res.render('clinicianPortal', { details: {}, history: [] });
});
router.post('/medicinehistory', function(req, res) {
    let medicalID = req.body.medicalID;
    let medicineID = medicalID + '0M'
    let doc = {
        'medicalID': medicineID
    }
    ehrClinician.getMedicineRecord(req, res, doc)
});

module.exports = router;
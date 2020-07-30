//Test Center Routes
const express = require('express');
const router = express.Router();
const passport = require('passport');
const ehrTestCenter = require('../../FabricHelpertestcenter');

//--------requires for text-extraction-------//
const fs = require("fs");
const pdfparse = require("pdf-parse");
const {
  TesseractWorker
} = require('tesseract.js'); 
const worker = new TesseractWorker();
const upload = require("express-fileupload");
router.use(upload());
//----------------------//

//All routes have prefix '/organisation/testcenter'
router.get('/login', (req, res) => {
  res.render('org/org-login', {
    org: 'testcenter'
  });
});

router.post('/login', passport.authenticate('local', {
  successRedirect: '/organisation/testcenter',
  failureRedirect: '/organisation/testcenter/login'
}), (req, res) => {

});

router.use((req, res, next) => {
  if (req.user.type == 'testcenter')
    next();
  else
    res.redirect('/');
});

router.get('/', (req, res) => {
  res.render('org/testcenter', {
    response: {}
  });
});

router.post('/addreport', (req, res) => {
  var MedicalID = req.body.medicalID;
  var bloodgroup = req.body.bloodGroup;
  var bloodpressure = req.body.bloodPressure;
  var haemoglobin = req.body.haemoglobin;
  var sugarlevel = req.body.sugarlevel;
  var links = req.body.links || ' ';
  var report = 'Blood Group:' + bloodgroup + ' ' + 'Blood Pressure:' + bloodpressure + ' ' + 'Haemoglobin:' + haemoglobin + ' ' + 'Glucose:' + sugarlevel;
  console.log(report);
  var doc = {
    'medicalID': MedicalID,
    'report': report,
    'links': links
  }

  //------------Text Extraction from pdf or image------------------//
  if (req.files) {
    var file = req.files.file;
    var fileName = file.name;
    if (file.mimetype == 'application/pdf') {
      file.mv("uploads/" + fileName, function (err) { // moving file to uploads folder
        if (err) { // if error occurs run this
          console.log("File was not uploaded!!");
          res.send(err);
        } else {
          console.log("file uploaded");
          const pdffile = fs.readFileSync("uploads/" + fileName); //read the file

          pdfparse(pdffile).then(function (data) { //text-extraction function
            var rawtext = data.text; //all the extracted text is stored in "rawtext" variable
            console.log(rawtext); //extracted text can be seen in the console
          });
        }
      });
    } else {
      file.mv("uploads/" + fileName, (err) => {
        if (err) { // if error occurs run this
          console.log("File was not uploaded!!");
          res.send(err);
        } else {
          console.log("file uploaded");
          fs.readFile(`./uploads/${fileName}`, (err, data) => {
            if (err)
              return console.log('Error reading file', err)

            worker
              .recognize(data, "eng", {
                tessjs_create_pdf: 0
              })
              .progress(progress => {
                console.log(progress)
              })
              .then(result => {
                const extractedText = result.text;
                console.log(extractedText);
                // res.send(extractedText);
              })

            // .finally(() => worker.terminate());
          })
        }
      })
    }
  }
});
//------------Text Extraction from pdf or image----------------//


// ehrTestCenter.addrLReport(req, res, doc);


module.exports = router;
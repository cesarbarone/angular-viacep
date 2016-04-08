// #hack for fix Promise is not defined from gulp-usemin
// global.Promise = require('bluebird');

var gulp          = require('gulp'),
    // connect       = require('gulp-connect'),
    // ngConstant    = require('gulp-ng-constant'),
    // rename        = require("gulp-rename"),
    coffee        = require('gulp-coffee'),
    gutil         = require('gulp-util'),
    // sourcemaps    = require('gulp-sourcemaps'),
    uglify = require('gulp-uglify'),
    // compass       = require('gulp-compass'),
    // // path          = require('path'),
    // wiredep       = require('wiredep').stream,
    // uglify        = require('gulp-uglify'),
    del           = require('del'),
    // concat        = require('gulp-concat'),
    // rev           = require('gulp-rev'),
    // usemin        = require('gulp-usemin'),
    // cleanCSS      = require('gulp-clean-css'),
    Server           = require('karma').Server;
    // protractor    = require("gulp-protractor").protractor,
    // protractorQA  = require('gulp-protractor-qa'),
    // templateCache = require('gulp-angular-templatecache'),
    // debug         = require("gulp-debug")
    // exec          = require('child_process').exec;


gulp.task('test', function (done) {
  new Server({
    configFile: __dirname + '/karma.conf.coffee',
    singleRun: true
  }, done).start();
});

gulp.task('clean:dist', function (cb) {
  console.log('Cleaning dist/ ...');
  return del([
    'dist/**/*',
  ], cb);
});

gulp.task('clean:tmp', ['clean:dist'], function (cb) {
  console.log('Cleaning tmp/ ...');
  return del([
    'tmp/**/*',
  ], cb);
});

gulp.task('coffee:dist', ['clean:tmp'], function() {
  return gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./tmp/'));
});

// mangle: Pass false to skip mangling names.
// gulp.task('compress', ['coffee:dist'], function() {
gulp.task('compress', ['coffee:dist'], function() {
  return gulp.src('tmp/*.js')
    .pipe(uglify())
    .pipe(gulp.dest('dist'));
});

// // Run gulp clean:dist before run gulp dist
gulp.task('dist',['compress']);

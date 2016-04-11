// #hack for fix Promise is not defined from gulp-usemin
// global.Promise = require('bluebird');

var gulp   = require('gulp'),
    rename = require("gulp-rename"),
    coffee = require('gulp-coffee'),
    gutil  = require('gulp-util'),
    uglify = require('gulp-uglify'),
    del    = require('del'),
    Server = require('karma').Server;

gulp.task('test', function (done) {
  new Server({
    configFile: __dirname + '/karma.conf.coffee',
    singleRun: false
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

gulp.task('copy:js', ['coffee:dist'], function() {
  gulp.src('./tmp/**/*')
    .pipe(gulp.dest('./dist/'))
});

gulp.task('compress', ['copy:js'], function() {
  return gulp.src('tmp/*.js')
    .pipe(uglify())
    .pipe(rename({
      suffix: '.min'
    }))
    .pipe(gulp.dest('dist'));
});

gulp.task('dist',['compress']);

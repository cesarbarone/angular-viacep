// #hack for fix Promise is not defined from gulp-usemin
// global.Promise = require('bluebird');

var gulp    = require('gulp'),
    rename  = require("gulp-rename"),
    connect = require('gulp-connect');
    coffee  = require('gulp-coffee'),
    gutil   = require('gulp-util'),
    uglify  = require('gulp-uglify'),
    debug   = require('gulp-debug'),
    del     = require('del'),
    pump    = require('pump'),
    concat  = require('gulp-concat-util'),
    Server  = require('karma').Server;


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
  return gulp.src(['./src/**', '!./src/**/*.spec.coffee'])
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./tmp/'));
});

gulp.task('compress', ['coffee:dist'], function(cb) {
  pump([
        gulp.src('./tmp/**/*.js'),
        debug({title: 'Files:'}),
        concat.scripts('angular-viacep.min.js'),
        uglify(),
        gulp.dest('dist/')
    ],
    cb
  );
  // return gulp.src()
  //   .pipe(debug({title: 'unicorn:'}))
  //   uglify()
  //   // .pipe(rename({
  //   //   suffix: '.min'
  //   // }))
  //   .pipe(gulp.dest('dist'));
});

gulp.task('serve', function() {
  connect.server({
    root: ['demo','tmp', 'dist'],
    livereload: true
  });
});

gulp.task('watch', function () {
  gulp.watch(['./src/**/*'], ['dist']);
});

gulp.task('default', ['serve', 'watch']);


gulp.task('dist',['compress']);

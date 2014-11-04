var del = require('del');
var gulp = require('gulp');
var wrap = require('gulp-wrap');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var sourcemaps = require('gulp-sourcemaps');
var livescript = require('gulp-livescript');


var vendorPath = function(relative) {
  return './lib/' + relative;
}


var paths = {
  scripts: {
    files: [
      './src/main.ls',
      './src/util.ls',
      './src/config.ls',
      './src/update.ls',
      './src/graphics.ls',
    ],
    vendor: {
      files: [
        vendorPath('prelude-ls/browser/prelude-browser-min.js'),
        vendorPath('jquery/dist/jquery.min.js'),
        vendorPath('color-js/color.js'),
        vendorPath('underscore/underscore-min.js'),
        vendorPath('p5js/lib/p5.js'),
        vendorPath('p5js/lib/addons/p5.dom.js'),
        vendorPath('p5js/lib/addons/p5.sound.js'),
      ],
      combinedName: 'combined-vendor.min.js',
    },
    combinedName: 'combined-scripts.min.js',
    outdir: './dist',
  },

  out: ['./dist'],
};


gulp.task('clean', function (cb) {
  del(paths.out, cb);
});


gulp.task('scripts', ['vendor'], function() {
  // Minify and copy all JavaScript (except vendor scripts)
  // with sourcemaps all the way down
  return gulp.src(paths.scripts.files)
    .pipe(livescript({ bare: true }))
    .pipe(uglify())
    .pipe(concat(paths.scripts.combinedName))
    .pipe(gulp.dest(paths.scripts.outdir));
});


gulp.task('vendor-scripts-dev', function() {
  return gulp.src(paths.scripts.vendor.files)
    .pipe(concat(paths.scripts.vendor.combinedName))
    .pipe(gulp.dest(paths.scripts.outdir));
});


gulp.task('vendor-maps', function() {
  // Jquery source maps
  return gulp.src(vendorPath('jquery/dist/jquery.min.map'))
    .pipe(gulp.dest(paths.scripts.outdir));
});


gulp.task('vendor', ['vendor-scripts-dev', 'vendor-maps']);


// Rerun the task when a file changes
gulp.task('watch', ['scripts'], function() {
  gulp.watch(paths.scripts.files, ['scripts']);
});


gulp.task('default', ['watch', 'vendor', 'scripts']);



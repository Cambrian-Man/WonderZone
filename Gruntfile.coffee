module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.initConfig
    coffee:
      compile:
        options:
          sourceMap: true
        files:
          'game/game.js': 'src/*.coffee'

    watch:
      coffee:
        files: ['src/*.coffee']
        tasks: ['coffee']

  grunt.registerTask 'default', ['coffee']
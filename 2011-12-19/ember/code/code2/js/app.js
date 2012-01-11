var App = Em.Application.create()
App.Board = Em.Object.extend({
  title: null,
});

App.board = App.Board.create({title: "drug.org.pl"});

App.boardController = Em.Object.create({
    model: App.board,
    titleBinding: 'model.title',
    titleChanged: function(title) { this.model.set('title', title); }
});

App.BoardView = Em.View.extend({
  controller: App.boardController,
  titleBinding: 'controller.title'
});

App.BoardConfigView = Em.TextField.extend({
  controller: App.boardController,
  valueBinding: 'controller.title',

    keyUp: function(e) {
      var title = this.$().val();
      this.controller.titleChanged(title);
    }
});

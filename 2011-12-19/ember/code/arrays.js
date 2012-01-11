App.User = Em.Object.extend({
  first_name: null,
  last_name: null,
  parents: [],

  full_name: Em.ComputedProperty(function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  }, 'first_name', 'last_name')
});

var user1 = App.User.create({first_name: 'bob', last_name: 'brown'});
var user2 = App.User.create({first_name: 'alice', last_name: 'brown'});

user1.parents.push(user2);

// user1.parents => [user2]
// BUT
// user2.parents => [user1]


App.User = Em.Object.extend({
  // ...
  init: function() {
    this.parents = [];
  }
});


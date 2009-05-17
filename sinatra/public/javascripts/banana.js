var utility = {
  //this will take a string template and use a hash as a map of key / value
  // search for the token of style ${something} where something will be used as the key in the value map.
	substitute: function(/*string*/ templ, /*object*/ map){
		return templ.replace(/\$\{([^\s\:\}]+)(?:\:([^\s\:\}]+))?\}/g, function(match, key, all){
		  return map[key];
		});
	}
}

var banana = {
  //template for standard row
	template_standard: '<li><p class="message"> ${message} <span class="meta">~ ${committed_date_pretty} by ${author_name} - ${nice_id}</span></p></li>',

  //template for row with a branch label
	template_master: '<li><em class="branch">${head}</em><p class="message"> ${message} <span class="meta">~ ${committed_date_pretty} by ${author_name} - ${nice_id}</span></p></li>',

  //fetch the index and use that to fetch json for each repository
	getData : function(){
		$.getJSON("/index.json", function(data) {
			$.each(data.repositories, function(i) {
				$.getJSON("/" + data.repositories[i].name + ".json", function(repository) {
				  banana.ajaxUpdate(repository);
				});
			});
		});  
	},

  //use a repository data object to populate the repository information
	ajaxUpdate: function( /*object*/ repository) {
		var container = $("#" + repository.html_friendly_name + " .commits");
		var headBranch = null;
		var remaining = [];
		$.each(repository.recent_commits, function(i) {
		  var commit = repository.recent_commits[i];
		  var template = banana.template_standard;
		  if (commit.head) {
		    template = banana.template_master;
		  }
		  commit.author_name = commit.author.name;
		  commit.nice_id = commit.id.substr(0, 7);
		  var messagePara = utility.substitute(template, commit);
		  if(commit.head){
		    headBranch = $(messagePara);
		  } else {
		    remaining.push(messagePara)
		  }
		});
    olderCommits = $(remaining.join(""));
    //clear out previous entries
    container.empty();
    if(headBranch) {
      container.append(headBranch)
    }
    container.append(olderCommits);
	}
}
var utility = {
	substitute: function(templ, map){
		return templ.replace(/\$\{([^\s\:\}]+)(?:\:([^\s\:\}]+))?\}/g, function(match, key, all){
		  return map[key];
		});
	}
}

var banana = {
	template_standard: '<li><p class="message"> ${message} <span class="meta">~ ${committed_date_pretty} by ${author_name} - ${nice_id}</span></p></li>',

	template_master: '<li><em class="branch">${head}</em><p class="message"> ${message} <span class="meta">~ ${committed_date_pretty} by ${author_name} - ${nice_id}</span></p></li>',

	getData : function(){
		$.getJSON("/index.json", function(data) {
			$.each(data.repositories, function(i) {
				$.getJSON("/" + data.repositories[i].name + ".json", function(repository) {
				  banana.ajaxUpdate(repository);
				});
			});
		});  
	},

	ajaxUpdate: function(repository) {
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
		  console.log(messagePara)
		  if(commit.head){
		    headBranch = $(messagePara);
		  } else {
		    remaining.push(messagePara)
		  }
		});
    olderCommits = $(remaining.join(""));
    container.empty();
    container.append(headBranch).append(olderCommits);
	}
}
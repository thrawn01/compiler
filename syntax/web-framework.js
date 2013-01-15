

route = RouteController()

// Add somthing that is very convention over configuration
route.add("/rails", RailsLikeController())
// Add somthing that is very MVC centric
route.add("/mvc", MVCController())
// Add a lift like controller with pure transforms
route.add("/lift", MyLift())

// Setup a REST like controller
rest = MyRest()
// add a filter that always return json
rest.add("/rest/json", Json())
// add a filter that preforms content negotiation 
rest.add("/rest/content", ContentNegotiation())
// Add the MyRest filter to the route filter
route.add("/rest", rest)

// Add authentication to the entire application
auth = AuthenticationController()
// Only allow access to this route if the someValidationMethod() returns true or some such thing
auth.only("/rest", someValidationMethod)
// Add authentication
route.add("/", auth)

// Serve up the application
serve(route)


class MyRest extends RestController(){

  // Define some routes to match
  self.route.add("/rest", "GET", self.index)

  def index(req) {
    // validate params
    // See Post.py

    // If we have auth enabled, get the authentication filter
    // and ask it for the user we logged in as
    user = req.filter('auth').getUser().else("no-user")

    // get params
    req.params.get("blah").else("default")
    return Ok("<h2>blah</h2>")
  }
}


class MyLift extends LiftLikeController {
  
  // Define some routes to match the page
  self.route.add("/lift", "/public/index.html")
  // Introduce the ajax controller
  self.ajax = AjaxController("lift/ajax")
  self.route.add(self.ajax)

  // Modify the session and return the modified session
  def Session index(Session session) {
    // Preform transforms on the session dom
    // select takes a anon function that returns an String or Element
    // and replaces the selected item with that (In this case, it is a string)
    session.dom.select("#time *", { Date.now().toString() })
  }

  // A method called on a <form> in index.html
  def Session renderUserForm(Session session) {
    session.dom.select("id=age", {
        // Add a onSubmit attribute to the <input>
        // that calls a generated /rest/{guid} handled by the AjaxController()
        // when the ajax controller calls the /rest/{guid}, the function passed
        // here is called
        self.ajax.onSubmit({ |element|
            if element.value.toInt() > 20 {
                // Do something
            }
        })
    })

    // Server side validation the entered username is available
    session.dom.select("id=username", {
        self.ajax.onChange({ |element|
            // See if the username is available
            if element.value == "derrick" {
                session.dom.select("id=username-checkbox", { |element|
                    element.href = "check-box.png"
                })
            }
        })
    })
  }
}



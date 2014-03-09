ruleset Foursquare {
  meta {
    name "Foursquare"
    description <<
      Interacts with foursquare.
    >>
    author "Mike Curtis"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }
  
  rule process_fs_checkin is active {
    select when foursquare checkin
    pre {
      checkin = event:attr("checkin").decode();
      venue = checkin.pick("$..venue.name").as("str");
      city = checkin.pick("$..city").as("str");
      shout = checkin.pick("$..shout").as("str");
      createdAt = checkin.pick("$..createdAt").as("str");
    }
    fired {
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;
    }
  }
  
  rule display_checkin is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Venue: #{ent:venue}</h5>
        <h5>City: #{ent:city}</h5>
        <h5>Shout: #{ent:shout}</h5>
        <h5>CreatedAt: #{ent:createdAt}</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("CS462 Lab 5: Foursquare Checkins", {}, my_html);
    }
  }
}

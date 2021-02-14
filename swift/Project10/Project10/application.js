//# sourceURL=application.js

//
//  application.js
//  Project10
//
//  Created by Jinwoo Kim on 2/14/21.
//

/*
 1: JavaScript에는 ES5와 ES6가 있다.
 2: ES5에서는 변수를 `var`, ES6에서는 `let`으로 선언한다.
 3: ES6에서는 상수는 `const`로 선언하며, ES5는 없다.
 4: JavaScript에는 type safety가 없다. 이는 JSON 파싱을 쉽게 만들어준다.
 5: ;은 요구될 때가 있고 아닐 때고 있지만, 안전하게 써주자.
 6: 괄호({})는 condition, loop에 요구된다.
 7: String은 ', ", '''으로 쓸 수 있으며, \은 ES6에 있다.
 8: Swift 처럼, JavaScript도 함수를 변수처럼 사용할 수 있고, parameter도 넣을 수 있다.
 10: JavaScript도 forEach, for...in이 있으며 ES6에서는 for...of가 있다.
 */

let genres = {};
let movies = {};

App.onLaunch = function(options) {
    // 앱의 경로(path)를 arg에 있는 options에서 얻어온다. this는 self(=App)을 뜻한다. zoomTrailer에서 App에 접근해서 가져온다.
    this.baseURL = options.BASEURL;

    // var alert = createAlert("Hello World!", "Welcome to tvOS");
    // navigationDocument.pushDocument(alert);
    const loading = createActivityIndicator("Loading feed...")
    navigationDocument.pushDocument(loading);

    loadData("https://itunes.apple.com/us/rss/topmovies/limit=2/json", parseJSON)
}


App.onWillResignActive = function() {

}

App.onDidEnterBackground = function() {

}

App.onWillEnterForeground = function() {
    
}

App.onDidBecomeActive = function() {
    
}


// 기본으로 있는 함수
var createAlert = function(title, description) {
    // https://developer.apple.com/documentation/tvml 참조
    var alertString = `<?xml version="1.0" encoding="UTF-8" ?>
        <document>
          <alertTemplate>
            <title>${title}</title>
            <description>${description}</description>
          </alertTemplate>
        </document>`

    var parser = new DOMParser();

    var alertDoc = parser.parseFromString(alertString, "application/xml");

    return alertDoc
}

function createActivityIndicator(title) {
  const markup = `<?xml version="1.0" encoding="UTF-8" ?>
  <document>
    <loadingTemplate>
      <activityIndicator>
        <text>${title}</text>
      </activityIndicator>
    </loadingTemplate>
  </document>`;

  return new DOMParser().parseFromString(markup, "application/xml")
}

function loadData(url, callback) {
  // 1: create the request object
  const request = new XMLHttpRequest;

  // 2: tell it to run our callback function when we have data
  request.addEventListener("load", function() { callback(request.response) });

  // 3: configure it to fetch the URL using GET
  request.open("GET", url)

  // 4: send the request
  request.send()
}

// JSON에서는 & 기호를 자유롭게 쓸 수 있지만, XML에서는 그렇지 않다. & 대신에 &amp; 기호를 써야 한다.
function fixXML(str) {
  return str.replace("&", "&amp;");
}

function parseJSON(text) {
  // convert the text to arrays and dictionaries
  const json = JSON.parse(text);

  // loop over all the movies we found
  for (entry of json["feed"]["entry"]) {
    // create a new movie object
    let movie = {};
    // set its properties from the JSON, using fixXML() for safety.
    movie.title = fixXML(entry["im:name"]["label"]);
    movie.genre = fixXML(entry["category"]["attributes"]["label"]);

    // 애플 JSON 버그가 있길래
    // movie.summary = fixXML(entry["summary"]["label"]);
    const summary = entry["summary"];
    if (summary != undefined) {
      movie.summary = fixXML(summary["label"]);
    } else {
      movie.summary = "(NULL)";
    }
    console.log(movie.summary);

    movie.director = fixXML(entry["im:artist"]["label"]);
    movie.releaseDate = fixXML(entry["im:releaseDate"]["attributes"]["label"]);
    movie.price = fixXML(entry["im:price"]["label"]);
    movie.coverURL = fixXML(entry["im:image"][2]["label"]);
    movie.link = fixXML(entry["link"][0]["attributes"]["href"]);
    movie.trailerURL = fixXML(entry["link"][1]["attributes"]["href"]);

    // print out the resulting move
    // console.log(movie);

    if (movie.genre in genres) {
      genres[movie.genre].push(movie);
    } else {
      genres[movie.genre] = [movie];
    }

    movies[movie.trailerURL] = movie;
  }

  const shelfTitles = Object.keys(genres).sort();
  const stack = createStackTemplate(shelfTitles);
  navigationDocument.replaceDocument(stack, navigationDocument.documents[0]);

  stack.addEventListener("play", playSelectedMovie);
  stack.addEventListener("select", zoomSelectedMovie);
}

// lockup : 하나에 여러개 있음 - Stack View 같은거
function createLockupElement(movie) {
  return `<lockup trailerURL="${movie.trailerURL}">
  <img width="250" height="370" src="${movie.coverURL}" />
  <title>${movie.title}</title>
  </lockup>`
}

function createShelfElement(genre) {
  return `<shelf>
  <header>
  <title>${genre}</title>
  </header>
  <section>
  ${genres[genre].map(createLockupElement).join("")}
  </section>
  </shelf>`;
}

function createStackTemplate(shelfTitles) {
  const markup = `<?xml version="1.0" encoding="UTF-8" ?>
  <document>
  <stackTemplate>
  <banner>
  <background>
  <img src="resource://banner" width="1920" height="500" />
  </background>
  </banner>

  <collectionList>
  ${shelfTitles.map(createShelfElement).join("")}
  </collectionList>
  </stackTemplate>
  </document>`;

  return new DOMParser().parseFromString(markup, "application/xml");
}

// 재생 버튼 눌렀을 때
function playSelectedMovie(event) {
  const selectedMovie = event.target;
  const trailerURL = selectedMovie.getAttribute("trailerURL");

  playMovie(trailerURL);
}

// select 버튼 눌렀을 때
function zoomSelectedMovie(event) {
  const selectedMovie = event.target;
  const trailerURL = selectedMovie.getAttribute("trailerURL");

  zoomTrailer(trailerURL);
}

// play 버튼을 눌렀을 때 영상을 재생한다. 
function playMovie(url) {
  const mediaItem = new MediaItem("video", url);
  mediaItem.title = "Trailer";

  const playlist = new Playlist();
  playlist.push(mediaItem);

  const player = new Player();
  player.playlist = playlist;

  player.play()
}

// select 버튼을 눌렀을 때 나오는 새로운 Document의 Stack은 작게 표시한다.
function createAlternativeMovie(movie) {
  return `<lockup trailerURL="${movie.trailerURL}">
  <img width="200" height="300" src="${movie.coverURL}" />
  <title>${movie.title}</title>
  </lockup>`;
}

function zoomTrailer(trailerURL) {
  const movie = movies[trailerURL];

  loadData(App.baseURL + "/product.xml", function (template) {
    template = template.replace(/\[GENRE\]/g, movie.genre);
    template = template.replace("[TITLE]", movie.title);
    template = template.replace("[SUMMARY]", movie.summary);
    template = template.replace("[COVERURL]", movie.coverURL);
    template = template.replace("[DIRECTOR]", movie.director);
    template = template.replace("[RELEASEDATE]", movie.releaseDate);
    template = template.replace("[PRICE]", `Available to buy on iTunes for ${movie.price}`);
    template = template.replace("[TRAILERURL]", movie.trailerURL);

    const otherMovies = genres[movie.genre];
    const alternatives = otherMovies.map(createAlternativeMovie).join("");
    template = template.replace("[ALTERNATIVES]", alternatives);

    let document = new DOMParser().parseFromString(template, "application/xml");
    
    document.addEventListener("select", handleProductEvent);
    document.addEventListener("play", handleProductEvent);

    navigationDocument.pushDocument(document);
  });
}

function handleProductEvent(event) {
  const target = event.target;

  if (target.tagName == "description") {
    const body = target.textContent;
    const alertDocument = createAlert('', body);
    navigationDocument.presentModal(alertDocument);
  } else if (target.tagName == "lockup") {
    const trailerURL = target.getAttribute("trailerURL");
    zoomTrailer(trailerURL);
  } else {
    const trailerURL = target.getAttribute("trailerURL");
    playMovie(trailerURL);
  }
}
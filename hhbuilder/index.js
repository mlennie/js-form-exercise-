var familyMembers = [];

function serialize() {
  var controls = ['input','select'],data = {},inputs,c,i;
  for (c = 0; c < controls.length; c++) {
    inputs = [].slice.call(document.forms[0].getElementsByTagName(controls[c]));
    for (i = 0; i < inputs.length; i++) {
      if (inputs[i].type == "checkbox") {
        data[inputs[i].name] = inputs[i].checked;
      } else {
        data[inputs[i].name] = inputs[i].value;
      }
    }
  }
  return data;
}

function dataValid(data) {
  return data && data.age && +data.age != NaN &&
         +data.age > 0 && data.rel && data.rel.length > 0;
}

function refreshList() {
  var html, member,age,rel,smoker;
  var list = document.getElementsByClassName('household')[0];
  list.innerHTML = "";
  for (var i = 0; i < familyMembers.length; i++) {
    html = "";
    member = familyMembers[i];
    age = "<p>Age: " + member.age + "</p>";
    rel = "<p>Relationship: " + member.rel + "</p>";
    smoker = "<p>Smoker: " + member.smoker + "</p>";
    remove = "<button class=\"remove\" id=\""+String(i)+"\">Remove</button>";
    html += "<li>"+age+rel+smoker+remove+"</li><hr>";
    list.insertAdjacentHTML('beforeend', html);
  }
  removeClickListener();
}

function newMemberSubmit(e) {
  var data = serialize();
  if (dataValid(data)) {
    familyMembers.push(data);
    refreshList();
  } else {
    var message = "Data is not valid. Age is required and must be a number " +
                  "greater than 0. Relationship is also required";
    alert(message);
  }

  e.preventDefault()
  e.stopPropagation();
}

function handleSubmit(e) {
    e.preventDefault()
    e.stopPropagation();
}

function removeMember(e) {
  var index = +e.target.id;
  familyMembers.splice(index, 1);
  refreshList();
}

function addClickListener() {
  document.getElementsByClassName("add")[0]
          .addEventListener("click", newMemberSubmit);
}

function submitClickListener() {
  document.forms[0]
          .addEventListener("submit", handleSubmit);
}

function removeClickListener() {
  var elements = document.getElementsByClassName("remove");
  for (var i = 0; i < elements.length; i++) {
    elements[i].addEventListener("click", removeMember);
  }
}

submitClickListener();
addClickListener();


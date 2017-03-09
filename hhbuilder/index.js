var familyMembers = [];

function serialize() {
  var controls = ['input','select'],data = {},inputs,c,i;
  for (c = 0; c < controls.length; c++) {
    inputs = [].slice.call(document.forms[0].getElementsByTagName(controls[c]));
    for (i = 0; i < inputs.length; i++) {
      data[inputs[i].name] = inputs[i].value;
    }
  }
  return data;
}

function dataValid(data) {
  return data.age && +data.age > 0 && data.rel && data.rel.length > 0;
}

function newMemberSubmit() {
debugger;
  var data = serialize();
  if (dataValid(data)) {
    familyMembers.push(data);
  } else {
    var message = "Data is not valid. Age is required and greater than 0." +
                  " Relationship is also required";
    alert(message);
  }

debugger;


}

function addClickListener() {
  document.getElementsByClassName("add")[0].addEventListener("click", newMemberSubmit);
}

addClickListener();


var familyMembers = [];

function serialize(e) {
  var controls = ['input','select'],data = {},inputs,c,i;
  for (c = 0; c < controls.length; c++) {
    inputs = [].slice.call(e.target.getElementsByTagName(controls[c]));
    for (i = 0; i < inputs.length; i++) {
      data[inputs[i].name] = inputs[i].value;
    }
  }
  return data;
}

function newMemberSubmit(form,e) {
  var data = serialize(e);

debugger;


}

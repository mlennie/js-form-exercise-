var familyMembers = [];

function getDataForControl(control,data,e) {
  var inputs = [].slice.call(e.target.getElementsByTagName(control));
  for (var i = 0; i < inputs.length; i++) {
    data[inputs[i].name] = inputs[i].value;
  }
  return data;
}

function serialize(e) {
  var data = {};
  data = getDataForControl('input',data,e);
  data = getDataForControl('select',data,e);
  return data;
}

function newMemberSubmit(form,e) {
  var data = serialize(e);

debugger;


}

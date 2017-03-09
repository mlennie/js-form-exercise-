var familyMembers = [];

function getDataForControl(control) {
  var data = {};
  var inputs = [].slice.call(e.target.getElementsByTagName(control));
  inputs.forEach(input => {
    data[input.name] = input.value;
  });
}

function serialize(e) {
  var data = {};
  data = getDataForControl('input',data,e);
  data = getDataForControl('select',data,e);
}

function newMemberSubmit(form,event) {
debugger;

}

// alanın adı: buildingsNumber template: buildings
var bAmount = Number(this.getField("buildingsNumber").value);
var t = this.getTemplate("buildings");

for (var i = 1; i <= bAmount; i++)
t.spawn(i, true, false);

//Global variable menüden form properties'in altından oluşturulur
// tipi her zaman string'dir. intCount adında oluşturalım
var a = parseInt(intCount.value) + 1 ; //Step 1
intCount.value = a.toString();   //Step 2
var b = parseInt(intCount.value) + 1;  //Step 3
intCount.value = b.toString();  //Step 4

// Tablo Sütun Toplamı - Birden fazla sayfayı destekler
var fields;
var total = 0;
var page = xfa.layout.page(this);
for(var j = 0 ; j < page; j++)
{
 fields = xfa.layout.pageContent(j, "field", 0);
 for (var i=0; i < fields.length; i++)
 {
  if (fields.item(i).name == "NETWR")
  {       
       total = total + fields.item(i).rawValue;            
  }
 }
}
this.rawValue = total;

// Form toplam
var fields = xfa.layout.pageContent(xfa.layout.page(this)-1, "field", 0);
var total = 0;
for (var i=0; i <= fields.length-1; i++) {
if (fields.item(i).name == "PRICE") {
total = total + fields.item(i).rawValue;
}
}
this.rawValue = total;

// Messagebox göster
xfa.host.messageBox("This is a message for a form filler.", "User Feedback", 3);
xfa.host.messageBox(xfa.event.name);
xfa.host.messageBox(xfa.event.prevText);

xfa.resolveNode("Sayfa4.#subform[1].GT_TABLE.DATA.X3").rawValue;

//textfield boş mu kontrolü
if(data.Sayfa2.topofpage.TextField10.rawValue != '' || data.Sayfa2.topofpage.TextField10.rawValue != null){
	this.rawValue = 'dolu';
}else{
	this.rawValue = 'bos';
}

 NumericField1.rawValue = NumericField1.rawValue + 1;

 txtCondition.assist.toolTip.value = "Conditions of purchase.";

// Dropdown menünün seçili elementini kontrol etme
if(this.parent.DropDownList2.selectedIndex == 1)

if (this.rawValue == 1) {
	this.presence = 'visible';
}
else{
	this.presence = 'hidden';
}

let expresionRegularIsbn="/(978|979)[-][0-9][-][0-9]{2}[-][0-9]{6}[-][0-9]/";
let prueba="/[a-zA-z0-9]{1,50}/"
let regExpresion= new RegExp(expresionRegularIsbn,'i');
let isbnElement= document.getElementById("isbn");
let botonCRUDLibro= document.getElementById("btn-libro");
let alerta= document.getElementById("alerta");
let titulo= document.getElementById("titulo");
let regExpresion_2= new RegExp(prueba);

/*
isbnElement.addEventListener('change',()=>{
  if(regExpresion.test(document.getElementById('isbn').value)==true){
            alerta.style.display="none";
  }
  else{
    botonCRUDLibro.disabled=true;
    alerta.style.display="block";
    alerta.innerText="El isbn es incorrecto " + document.getElementById("isbn").value;
  }
});
*/

titulo.addEventListener(
  "change",()=>{
    if(regExpresion_2.test(document.getElementById("titulo").value)==true){
        botonCRUDLibro.disabled=false;
    }
    else{
      alerta.innerText="El tiutlo no puede estar vacío";
    }
  }
);
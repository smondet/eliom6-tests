(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

[%%shared.start]

module type Page = sig

  val name : string

  val page_class : string

  val service :
    (unit, unit,
     Eliom_service.get,
     Eliom_service.att,
     Eliom_service.non_co,
     Eliom_service.non_ext,
     Eliom_service.reg,
     [ `WithoutSuffix ],
     unit, unit,
     Eliom_service.non_ocaml)
      Eliom_service.t

  val page :
    unit ->
    ([`P | `Div | `Input] Eliom_content.Html.D.elt) list Lwt.t

end

let demos =
  [ (module Demo_popup : Page)
  ; (module Demo_rpc)
  ; (module Demo_ref)
  ; (module Demo_spinner)
  ; (module Demo_pgocaml)
  ; (module Demo_carousel1)
  ; (module Demo_carousel2)
  ; (module Demo_carousel3)
  ; (module Demo_calendar)
  ; (module Demo_timepicker)
  ; (module Demo_notif)
  ; (module Demo_react)
  ]

let drawer_contents () =
  let open Eliom_content.Html.F in
  let make_link (module D : Page) =
    li [ a ~service:D.service [pcdata @@ D.name] () ]
  in
  let submenu =
    ul ~a:[a_class ["os-drawer-submenu"]] (List.map make_link demos)
  in
  li [ a ~a:[ a_class ["os-drawer-item"] ]
         ~service:Zero_services.demo_service
         [pcdata "Demo"] ()
     ; submenu ]

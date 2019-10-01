
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: GalleryManagementClient
## version: 2015-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Admin Gallery Management Client.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_574442 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574442](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574442): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "azsadmin-GalleryItem"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GalleryItemsCreate_574980 = ref object of OpenApiRestCall_574442
proc url_GalleryItemsCreate_574982(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.gallery.admin/galleryItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryItemsCreate_574981(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574992 = path.getOrDefault("subscriptionId")
  valid_574992 = validateParameter(valid_574992, JString, required = true,
                                 default = nil)
  if valid_574992 != nil:
    section.add "subscriptionId", valid_574992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574993 = query.getOrDefault("api-version")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574993 != nil:
    section.add "api-version", valid_574993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   galleryItemUri: JObject (required)
  ##                 : The URI to the gallery item JSON file.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574995: Call_GalleryItemsCreate_574980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574995.validator(path, query, header, formData, body)
  let scheme = call_574995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574995.url(scheme.get, call_574995.host, call_574995.base,
                         call_574995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574995, url, valid)

proc call*(call_574996: Call_GalleryItemsCreate_574980; subscriptionId: string;
          galleryItemUri: JsonNode; apiVersion: string = "2016-05-01"): Recallable =
  ## galleryItemsCreate
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   galleryItemUri: JObject (required)
  ##                 : The URI to the gallery item JSON file.
  var path_574997 = newJObject()
  var query_574998 = newJObject()
  var body_574999 = newJObject()
  add(query_574998, "api-version", newJString(apiVersion))
  add(path_574997, "subscriptionId", newJString(subscriptionId))
  if galleryItemUri != nil:
    body_574999 = galleryItemUri
  result = call_574996.call(path_574997, query_574998, nil, nil, body_574999)

var galleryItemsCreate* = Call_GalleryItemsCreate_574980(
    name: "galleryItemsCreate", meth: HttpMethod.HttpPost,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/microsoft.gallery.admin/galleryItems",
    validator: validate_GalleryItemsCreate_574981, base: "",
    url: url_GalleryItemsCreate_574982, schemes: {Scheme.Https})
type
  Call_GalleryItemsList_574664 = ref object of OpenApiRestCall_574442
proc url_GalleryItemsList_574666(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.gallery.admin/galleryItems")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryItemsList_574665(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574826 = path.getOrDefault("subscriptionId")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "subscriptionId", valid_574826
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574840 = query.getOrDefault("api-version")
  valid_574840 = validateParameter(valid_574840, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574840 != nil:
    section.add "api-version", valid_574840
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574867: Call_GalleryItemsList_574664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574867.validator(path, query, header, formData, body)
  let scheme = call_574867.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574867.url(scheme.get, call_574867.host, call_574867.base,
                         call_574867.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574867, url, valid)

proc call*(call_574938: Call_GalleryItemsList_574664; subscriptionId: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## galleryItemsList
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574939 = newJObject()
  var query_574941 = newJObject()
  add(query_574941, "api-version", newJString(apiVersion))
  add(path_574939, "subscriptionId", newJString(subscriptionId))
  result = call_574938.call(path_574939, query_574941, nil, nil, nil)

var galleryItemsList* = Call_GalleryItemsList_574664(name: "galleryItemsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/microsoft.gallery.admin/galleryItems",
    validator: validate_GalleryItemsList_574665, base: "",
    url: url_GalleryItemsList_574666, schemes: {Scheme.Https})
type
  Call_GalleryItemsGet_575000 = ref object of OpenApiRestCall_574442
proc url_GalleryItemsGet_575002(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "galleryItemName" in path, "`galleryItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.gallery.admin/galleryItems/"),
               (kind: VariableSegment, value: "galleryItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryItemsGet_575001(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryItemName: JString (required)
  ##                  : Identity of the gallery item. Includes publisher name, item name, and may include version separated by period character.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryItemName` field"
  var valid_575003 = path.getOrDefault("galleryItemName")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "galleryItemName", valid_575003
  var valid_575004 = path.getOrDefault("subscriptionId")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "subscriptionId", valid_575004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575005 = query.getOrDefault("api-version")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575005 != nil:
    section.add "api-version", valid_575005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575006: Call_GalleryItemsGet_575000; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575006.validator(path, query, header, formData, body)
  let scheme = call_575006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575006.url(scheme.get, call_575006.host, call_575006.base,
                         call_575006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575006, url, valid)

proc call*(call_575007: Call_GalleryItemsGet_575000; galleryItemName: string;
          subscriptionId: string; apiVersion: string = "2016-05-01"): Recallable =
  ## galleryItemsGet
  ##   galleryItemName: string (required)
  ##                  : Identity of the gallery item. Includes publisher name, item name, and may include version separated by period character.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575008 = newJObject()
  var query_575009 = newJObject()
  add(path_575008, "galleryItemName", newJString(galleryItemName))
  add(query_575009, "api-version", newJString(apiVersion))
  add(path_575008, "subscriptionId", newJString(subscriptionId))
  result = call_575007.call(path_575008, query_575009, nil, nil, nil)

var galleryItemsGet* = Call_GalleryItemsGet_575000(name: "galleryItemsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/microsoft.gallery.admin/galleryItems/{galleryItemName}",
    validator: validate_GalleryItemsGet_575001, base: "", url: url_GalleryItemsGet_575002,
    schemes: {Scheme.Https})
type
  Call_GalleryItemsDelete_575010 = ref object of OpenApiRestCall_574442
proc url_GalleryItemsDelete_575012(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "galleryItemName" in path, "`galleryItemName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.gallery.admin/galleryItems/"),
               (kind: VariableSegment, value: "galleryItemName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GalleryItemsDelete_575011(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   galleryItemName: JString (required)
  ##                  : Identity of the gallery item. Includes publisher name, item name, and may include version separated by period character.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `galleryItemName` field"
  var valid_575013 = path.getOrDefault("galleryItemName")
  valid_575013 = validateParameter(valid_575013, JString, required = true,
                                 default = nil)
  if valid_575013 != nil:
    section.add "galleryItemName", valid_575013
  var valid_575014 = path.getOrDefault("subscriptionId")
  valid_575014 = validateParameter(valid_575014, JString, required = true,
                                 default = nil)
  if valid_575014 != nil:
    section.add "subscriptionId", valid_575014
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575015 = query.getOrDefault("api-version")
  valid_575015 = validateParameter(valid_575015, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575015 != nil:
    section.add "api-version", valid_575015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575016: Call_GalleryItemsDelete_575010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_575016.validator(path, query, header, formData, body)
  let scheme = call_575016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575016.url(scheme.get, call_575016.host, call_575016.base,
                         call_575016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575016, url, valid)

proc call*(call_575017: Call_GalleryItemsDelete_575010; galleryItemName: string;
          subscriptionId: string; apiVersion: string = "2016-05-01"): Recallable =
  ## galleryItemsDelete
  ##   galleryItemName: string (required)
  ##                  : Identity of the gallery item. Includes publisher name, item name, and may include version separated by period character.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575018 = newJObject()
  var query_575019 = newJObject()
  add(path_575018, "galleryItemName", newJString(galleryItemName))
  add(query_575019, "api-version", newJString(apiVersion))
  add(path_575018, "subscriptionId", newJString(subscriptionId))
  result = call_575017.call(path_575018, query_575019, nil, nil, nil)

var galleryItemsDelete* = Call_GalleryItemsDelete_575010(
    name: "galleryItemsDelete", meth: HttpMethod.HttpDelete,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/providers/microsoft.gallery.admin/galleryItems/{galleryItemName}",
    validator: validate_GalleryItemsDelete_575011, base: "",
    url: url_GalleryItemsDelete_575012, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)


import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## File share operation endpoints and objects.
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
  macServiceName = "azsadmin-FileShare"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FileSharesList_574664 = ref object of OpenApiRestCall_574442
proc url_FileSharesList_574666(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/fileShares")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesList_574665(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns a list of all fabric file shares at a certain location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574827 = path.getOrDefault("resourceGroupName")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "resourceGroupName", valid_574827
  var valid_574828 = path.getOrDefault("subscriptionId")
  valid_574828 = validateParameter(valid_574828, JString, required = true,
                                 default = nil)
  if valid_574828 != nil:
    section.add "subscriptionId", valid_574828
  var valid_574829 = path.getOrDefault("location")
  valid_574829 = validateParameter(valid_574829, JString, required = true,
                                 default = nil)
  if valid_574829 != nil:
    section.add "location", valid_574829
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574843 = query.getOrDefault("api-version")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574843 != nil:
    section.add "api-version", valid_574843
  var valid_574844 = query.getOrDefault("$filter")
  valid_574844 = validateParameter(valid_574844, JString, required = false,
                                 default = nil)
  if valid_574844 != nil:
    section.add "$filter", valid_574844
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574871: Call_FileSharesList_574664; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all fabric file shares at a certain location.
  ## 
  let valid = call_574871.validator(path, query, header, formData, body)
  let scheme = call_574871.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574871.url(scheme.get, call_574871.host, call_574871.base,
                         call_574871.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574871, url, valid)

proc call*(call_574942: Call_FileSharesList_574664; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## fileSharesList
  ## Returns a list of all fabric file shares at a certain location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574943 = newJObject()
  var query_574945 = newJObject()
  add(path_574943, "resourceGroupName", newJString(resourceGroupName))
  add(query_574945, "api-version", newJString(apiVersion))
  add(path_574943, "subscriptionId", newJString(subscriptionId))
  add(path_574943, "location", newJString(location))
  add(query_574945, "$filter", newJString(Filter))
  result = call_574942.call(path_574943, query_574945, nil, nil, nil)

var fileSharesList* = Call_FileSharesList_574664(name: "fileSharesList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/fileShares",
    validator: validate_FileSharesList_574665, base: "", url: url_FileSharesList_574666,
    schemes: {Scheme.Https})
type
  Call_FileSharesGet_574984 = ref object of OpenApiRestCall_574442
proc url_FileSharesGet_574986(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "fileShare" in path, "`fileShare` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/fileShares/"),
               (kind: VariableSegment, value: "fileShare")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FileSharesGet_574985(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the requested fabric file share.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   fileShare: JString (required)
  ##            : Fabric file share name.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574996 = path.getOrDefault("resourceGroupName")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "resourceGroupName", valid_574996
  var valid_574997 = path.getOrDefault("subscriptionId")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "subscriptionId", valid_574997
  var valid_574998 = path.getOrDefault("fileShare")
  valid_574998 = validateParameter(valid_574998, JString, required = true,
                                 default = nil)
  if valid_574998 != nil:
    section.add "fileShare", valid_574998
  var valid_574999 = path.getOrDefault("location")
  valid_574999 = validateParameter(valid_574999, JString, required = true,
                                 default = nil)
  if valid_574999 != nil:
    section.add "location", valid_574999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575000 = query.getOrDefault("api-version")
  valid_575000 = validateParameter(valid_575000, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575000 != nil:
    section.add "api-version", valid_575000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575001: Call_FileSharesGet_574984; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested fabric file share.
  ## 
  let valid = call_575001.validator(path, query, header, formData, body)
  let scheme = call_575001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575001.url(scheme.get, call_575001.host, call_575001.base,
                         call_575001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575001, url, valid)

proc call*(call_575002: Call_FileSharesGet_574984; resourceGroupName: string;
          subscriptionId: string; fileShare: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## fileSharesGet
  ## Returns the requested fabric file share.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   fileShare: string (required)
  ##            : Fabric file share name.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_575003 = newJObject()
  var query_575004 = newJObject()
  add(path_575003, "resourceGroupName", newJString(resourceGroupName))
  add(query_575004, "api-version", newJString(apiVersion))
  add(path_575003, "subscriptionId", newJString(subscriptionId))
  add(path_575003, "fileShare", newJString(fileShare))
  add(path_575003, "location", newJString(location))
  result = call_575002.call(path_575003, query_575004, nil, nil, nil)

var fileSharesGet* = Call_FileSharesGet_574984(name: "fileSharesGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/fileShares/{fileShare}",
    validator: validate_FileSharesGet_574985, base: "", url: url_FileSharesGet_574986,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

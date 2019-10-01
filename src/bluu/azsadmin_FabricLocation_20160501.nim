
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Fabric location operation endpoints and objects.
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

  OpenApiRestCall_574441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-FabricLocation"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FabricLocationsList_574663 = ref object of OpenApiRestCall_574441
proc url_FabricLocationsList_574665(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FabricLocationsList_574664(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of all fabric locations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574826 = path.getOrDefault("resourceGroupName")
  valid_574826 = validateParameter(valid_574826, JString, required = true,
                                 default = nil)
  if valid_574826 != nil:
    section.add "resourceGroupName", valid_574826
  var valid_574827 = path.getOrDefault("subscriptionId")
  valid_574827 = validateParameter(valid_574827, JString, required = true,
                                 default = nil)
  if valid_574827 != nil:
    section.add "subscriptionId", valid_574827
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  var valid_574842 = query.getOrDefault("$filter")
  valid_574842 = validateParameter(valid_574842, JString, required = false,
                                 default = nil)
  if valid_574842 != nil:
    section.add "$filter", valid_574842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574869: Call_FabricLocationsList_574663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all fabric locations.
  ## 
  let valid = call_574869.validator(path, query, header, formData, body)
  let scheme = call_574869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574869.url(scheme.get, call_574869.host, call_574869.base,
                         call_574869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574869, url, valid)

proc call*(call_574940: Call_FabricLocationsList_574663; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2016-05-01";
          Filter: string = ""): Recallable =
  ## fabricLocationsList
  ## Returns a list of all fabric locations.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574941 = newJObject()
  var query_574943 = newJObject()
  add(path_574941, "resourceGroupName", newJString(resourceGroupName))
  add(query_574943, "api-version", newJString(apiVersion))
  add(path_574941, "subscriptionId", newJString(subscriptionId))
  add(query_574943, "$filter", newJString(Filter))
  result = call_574940.call(path_574941, query_574943, nil, nil, nil)

var fabricLocationsList* = Call_FabricLocationsList_574663(
    name: "fabricLocationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations",
    validator: validate_FabricLocationsList_574664, base: "",
    url: url_FabricLocationsList_574665, schemes: {Scheme.Https})
type
  Call_FabricLocationsGet_574982 = ref object of OpenApiRestCall_574441
proc url_FabricLocationsGet_574984(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "fabricLocation" in path, "`fabricLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "fabricLocation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FabricLocationsGet_574983(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the requested fabric location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   fabricLocation: JString (required)
  ##                 : Fabric location.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574994 = path.getOrDefault("resourceGroupName")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "resourceGroupName", valid_574994
  var valid_574995 = path.getOrDefault("fabricLocation")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "fabricLocation", valid_574995
  var valid_574996 = path.getOrDefault("subscriptionId")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = nil)
  if valid_574996 != nil:
    section.add "subscriptionId", valid_574996
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_FabricLocationsGet_574982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested fabric location.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_FabricLocationsGet_574982; resourceGroupName: string;
          fabricLocation: string; subscriptionId: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## fabricLocationsGet
  ## Returns the requested fabric location.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   fabricLocation: string (required)
  ##                 : Fabric location.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_575000 = newJObject()
  var query_575001 = newJObject()
  add(path_575000, "resourceGroupName", newJString(resourceGroupName))
  add(path_575000, "fabricLocation", newJString(fabricLocation))
  add(query_575001, "api-version", newJString(apiVersion))
  add(path_575000, "subscriptionId", newJString(subscriptionId))
  result = call_574999.call(path_575000, query_575001, nil, nil, nil)

var fabricLocationsGet* = Call_FabricLocationsGet_574982(
    name: "fabricLocationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{fabricLocation}",
    validator: validate_FabricLocationsGet_574983, base: "",
    url: url_FabricLocationsGet_574984, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

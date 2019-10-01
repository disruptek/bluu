
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: UpdateAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Update location operation endpoints and objects.
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
  macServiceName = "azsadmin-UpdateLocations"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_UpdateLocationsList_574664 = ref object of OpenApiRestCall_574442
proc url_UpdateLocationsList_574666(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateLocationsList_574665(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the list of update locations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
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
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574841 = query.getOrDefault("api-version")
  valid_574841 = validateParameter(valid_574841, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574841 != nil:
    section.add "api-version", valid_574841
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574868: Call_UpdateLocationsList_574664; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of update locations.
  ## 
  let valid = call_574868.validator(path, query, header, formData, body)
  let scheme = call_574868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574868.url(scheme.get, call_574868.host, call_574868.base,
                         call_574868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574868, url, valid)

proc call*(call_574939: Call_UpdateLocationsList_574664; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2016-05-01"): Recallable =
  ## updateLocationsList
  ## Get the list of update locations.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  var path_574940 = newJObject()
  var query_574942 = newJObject()
  add(path_574940, "resourceGroupName", newJString(resourceGroupName))
  add(query_574942, "api-version", newJString(apiVersion))
  add(path_574940, "subscriptionId", newJString(subscriptionId))
  result = call_574939.call(path_574940, query_574942, nil, nil, nil)

var updateLocationsList* = Call_UpdateLocationsList_574664(
    name: "updateLocationsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/",
    validator: validate_UpdateLocationsList_574665, base: "",
    url: url_UpdateLocationsList_574666, schemes: {Scheme.Https})
type
  Call_UpdateLocationsGet_574981 = ref object of OpenApiRestCall_574442
proc url_UpdateLocationsGet_574983(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "updateLocation" in path, "`updateLocation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Update.Admin/updateLocations/"),
               (kind: VariableSegment, value: "updateLocation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateLocationsGet_574982(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get an update location based on name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: JString (required)
  ##                 : The name of the update location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574993 = path.getOrDefault("resourceGroupName")
  valid_574993 = validateParameter(valid_574993, JString, required = true,
                                 default = nil)
  if valid_574993 != nil:
    section.add "resourceGroupName", valid_574993
  var valid_574994 = path.getOrDefault("subscriptionId")
  valid_574994 = validateParameter(valid_574994, JString, required = true,
                                 default = nil)
  if valid_574994 != nil:
    section.add "subscriptionId", valid_574994
  var valid_574995 = path.getOrDefault("updateLocation")
  valid_574995 = validateParameter(valid_574995, JString, required = true,
                                 default = nil)
  if valid_574995 != nil:
    section.add "updateLocation", valid_574995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574996 = query.getOrDefault("api-version")
  valid_574996 = validateParameter(valid_574996, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574996 != nil:
    section.add "api-version", valid_574996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574997: Call_UpdateLocationsGet_574981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get an update location based on name.
  ## 
  let valid = call_574997.validator(path, query, header, formData, body)
  let scheme = call_574997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574997.url(scheme.get, call_574997.host, call_574997.base,
                         call_574997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574997, url, valid)

proc call*(call_574998: Call_UpdateLocationsGet_574981; resourceGroupName: string;
          subscriptionId: string; updateLocation: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## updateLocationsGet
  ## Get an update location based on name.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription.  The subscription ID forms part of the URI for every service call.
  ##   updateLocation: string (required)
  ##                 : The name of the update location.
  var path_574999 = newJObject()
  var query_575000 = newJObject()
  add(path_574999, "resourceGroupName", newJString(resourceGroupName))
  add(query_575000, "api-version", newJString(apiVersion))
  add(path_574999, "subscriptionId", newJString(subscriptionId))
  add(path_574999, "updateLocation", newJString(updateLocation))
  result = call_574998.call(path_574999, query_575000, nil, nil, nil)

var updateLocationsGet* = Call_UpdateLocationsGet_574981(
    name: "updateLocationsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Update.Admin/updateLocations/{updateLocation}",
    validator: validate_UpdateLocationsGet_574982, base: "",
    url: url_UpdateLocationsGet_574983, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)


import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: FabricAdminClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Compute operation results.
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

  OpenApiRestCall_582441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_582441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_582441): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-ComputeOperationResults"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ComputeOperationResultsList_582663 = ref object of OpenApiRestCall_582441
proc url_ComputeOperationResultsList_582665(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/computeOperationResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeOperationResultsList_582664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of all compute operation results at a location.
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
  var valid_582826 = path.getOrDefault("resourceGroupName")
  valid_582826 = validateParameter(valid_582826, JString, required = true,
                                 default = nil)
  if valid_582826 != nil:
    section.add "resourceGroupName", valid_582826
  var valid_582827 = path.getOrDefault("subscriptionId")
  valid_582827 = validateParameter(valid_582827, JString, required = true,
                                 default = nil)
  if valid_582827 != nil:
    section.add "subscriptionId", valid_582827
  var valid_582828 = path.getOrDefault("location")
  valid_582828 = validateParameter(valid_582828, JString, required = true,
                                 default = nil)
  if valid_582828 != nil:
    section.add "location", valid_582828
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582842 = query.getOrDefault("api-version")
  valid_582842 = validateParameter(valid_582842, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582842 != nil:
    section.add "api-version", valid_582842
  var valid_582843 = query.getOrDefault("$filter")
  valid_582843 = validateParameter(valid_582843, JString, required = false,
                                 default = nil)
  if valid_582843 != nil:
    section.add "$filter", valid_582843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_582870: Call_ComputeOperationResultsList_582663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of all compute operation results at a location.
  ## 
  let valid = call_582870.validator(path, query, header, formData, body)
  let scheme = call_582870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_582870.url(scheme.get, call_582870.host, call_582870.base,
                         call_582870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_582870, url, valid)

proc call*(call_582941: Call_ComputeOperationResultsList_582663;
          resourceGroupName: string; subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## computeOperationResultsList
  ## Returns a list of all compute operation results at a location.
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
  var path_582942 = newJObject()
  var query_582944 = newJObject()
  add(path_582942, "resourceGroupName", newJString(resourceGroupName))
  add(query_582944, "api-version", newJString(apiVersion))
  add(path_582942, "subscriptionId", newJString(subscriptionId))
  add(path_582942, "location", newJString(location))
  add(query_582944, "$filter", newJString(Filter))
  result = call_582941.call(path_582942, query_582944, nil, nil, nil)

var computeOperationResultsList* = Call_ComputeOperationResultsList_582663(
    name: "computeOperationResultsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/computeOperationResults",
    validator: validate_ComputeOperationResultsList_582664, base: "",
    url: url_ComputeOperationResultsList_582665, schemes: {Scheme.Https})
type
  Call_ComputeOperationResultsGet_582983 = ref object of OpenApiRestCall_582441
proc url_ComputeOperationResultsGet_582985(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "operation" in path, "`operation` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Fabric.Admin/fabricLocations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/computeOperationResults/"),
               (kind: VariableSegment, value: "operation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComputeOperationResultsGet_582984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the status of a compute operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the resource group.
  ##   operation: JString (required)
  ##            : Operation identifier.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Location of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_582995 = path.getOrDefault("resourceGroupName")
  valid_582995 = validateParameter(valid_582995, JString, required = true,
                                 default = nil)
  if valid_582995 != nil:
    section.add "resourceGroupName", valid_582995
  var valid_582996 = path.getOrDefault("operation")
  valid_582996 = validateParameter(valid_582996, JString, required = true,
                                 default = nil)
  if valid_582996 != nil:
    section.add "operation", valid_582996
  var valid_582997 = path.getOrDefault("subscriptionId")
  valid_582997 = validateParameter(valid_582997, JString, required = true,
                                 default = nil)
  if valid_582997 != nil:
    section.add "subscriptionId", valid_582997
  var valid_582998 = path.getOrDefault("location")
  valid_582998 = validateParameter(valid_582998, JString, required = true,
                                 default = nil)
  if valid_582998 != nil:
    section.add "location", valid_582998
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_582999 = query.getOrDefault("api-version")
  valid_582999 = validateParameter(valid_582999, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_582999 != nil:
    section.add "api-version", valid_582999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_583000: Call_ComputeOperationResultsGet_582983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the status of a compute operation.
  ## 
  let valid = call_583000.validator(path, query, header, formData, body)
  let scheme = call_583000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_583000.url(scheme.get, call_583000.host, call_583000.base,
                         call_583000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_583000, url, valid)

proc call*(call_583001: Call_ComputeOperationResultsGet_582983;
          resourceGroupName: string; operation: string; subscriptionId: string;
          location: string; apiVersion: string = "2016-05-01"): Recallable =
  ## computeOperationResultsGet
  ## Returns the status of a compute operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   operation: string (required)
  ##            : Operation identifier.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Location of the resource.
  var path_583002 = newJObject()
  var query_583003 = newJObject()
  add(path_583002, "resourceGroupName", newJString(resourceGroupName))
  add(query_583003, "api-version", newJString(apiVersion))
  add(path_583002, "operation", newJString(operation))
  add(path_583002, "subscriptionId", newJString(subscriptionId))
  add(path_583002, "location", newJString(location))
  result = call_583001.call(path_583002, query_583003, nil, nil, nil)

var computeOperationResultsGet* = Call_ComputeOperationResultsGet_582983(
    name: "computeOperationResultsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Fabric.Admin/fabricLocations/{location}/computeOperationResults/{operation}",
    validator: validate_ComputeOperationResultsGet_582984, base: "",
    url: url_ComputeOperationResultsGet_582985, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

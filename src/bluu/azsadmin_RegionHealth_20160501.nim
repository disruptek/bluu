
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: InfrastructureInsightsManagementClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Region health operation endpoints and objects.
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

  OpenApiRestCall_574459 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574459](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574459): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-RegionHealth"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RegionHealthsList_574681 = ref object of OpenApiRestCall_574459
proc url_RegionHealthsList_574683(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionHealthsList_574682(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns the list of all health status for the region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574844 = path.getOrDefault("resourceGroupName")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "resourceGroupName", valid_574844
  var valid_574845 = path.getOrDefault("subscriptionId")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "subscriptionId", valid_574845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574859 = query.getOrDefault("api-version")
  valid_574859 = validateParameter(valid_574859, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574859 != nil:
    section.add "api-version", valid_574859
  var valid_574860 = query.getOrDefault("$filter")
  valid_574860 = validateParameter(valid_574860, JString, required = false,
                                 default = nil)
  if valid_574860 != nil:
    section.add "$filter", valid_574860
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574887: Call_RegionHealthsList_574681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the list of all health status for the region.
  ## 
  let valid = call_574887.validator(path, query, header, formData, body)
  let scheme = call_574887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574887.url(scheme.get, call_574887.host, call_574887.base,
                         call_574887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574887, url, valid)

proc call*(call_574958: Call_RegionHealthsList_574681; resourceGroupName: string;
          subscriptionId: string; apiVersion: string = "2016-05-01";
          Filter: string = ""): Recallable =
  ## regionHealthsList
  ## Returns the list of all health status for the region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574959 = newJObject()
  var query_574961 = newJObject()
  add(path_574959, "resourceGroupName", newJString(resourceGroupName))
  add(query_574961, "api-version", newJString(apiVersion))
  add(path_574959, "subscriptionId", newJString(subscriptionId))
  add(query_574961, "$filter", newJString(Filter))
  result = call_574958.call(path_574959, query_574961, nil, nil, nil)

var regionHealthsList* = Call_RegionHealthsList_574681(name: "regionHealthsList",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths",
    validator: validate_RegionHealthsList_574682, base: "",
    url: url_RegionHealthsList_574683, schemes: {Scheme.Https})
type
  Call_RegionHealthsGet_575000 = ref object of OpenApiRestCall_574459
proc url_RegionHealthsGet_575002(protocol: Scheme; host: string; base: string;
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
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RegionHealthsGet_575001(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns the requested health status of a region.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the region
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575003 = path.getOrDefault("resourceGroupName")
  valid_575003 = validateParameter(valid_575003, JString, required = true,
                                 default = nil)
  if valid_575003 != nil:
    section.add "resourceGroupName", valid_575003
  var valid_575004 = path.getOrDefault("subscriptionId")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "subscriptionId", valid_575004
  var valid_575005 = path.getOrDefault("location")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "location", valid_575005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575006 = query.getOrDefault("api-version")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575006 != nil:
    section.add "api-version", valid_575006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575007: Call_RegionHealthsGet_575000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested health status of a region.
  ## 
  let valid = call_575007.validator(path, query, header, formData, body)
  let scheme = call_575007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575007.url(scheme.get, call_575007.host, call_575007.base,
                         call_575007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575007, url, valid)

proc call*(call_575008: Call_RegionHealthsGet_575000; resourceGroupName: string;
          subscriptionId: string; location: string;
          apiVersion: string = "2016-05-01"): Recallable =
  ## regionHealthsGet
  ## Returns the requested health status of a region.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the region
  var path_575009 = newJObject()
  var query_575010 = newJObject()
  add(path_575009, "resourceGroupName", newJString(resourceGroupName))
  add(query_575010, "api-version", newJString(apiVersion))
  add(path_575009, "subscriptionId", newJString(subscriptionId))
  add(path_575009, "location", newJString(location))
  result = call_575008.call(path_575009, query_575010, nil, nil, nil)

var regionHealthsGet* = Call_RegionHealthsGet_575000(name: "regionHealthsGet",
    meth: HttpMethod.HttpGet, host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}",
    validator: validate_RegionHealthsGet_575001, base: "",
    url: url_RegionHealthsGet_575002, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

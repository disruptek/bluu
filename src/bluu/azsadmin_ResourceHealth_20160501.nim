
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: InfrastructureInsightsManagementClient
## version: 2016-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Resource health operation endpoints and objects.
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

  OpenApiRestCall_574458 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574458](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574458): Option[Scheme] {.used.} =
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
  macServiceName = "azsadmin-ResourceHealth"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ResourceHealthsList_574680 = ref object of OpenApiRestCall_574458
proc url_ResourceHealthsList_574682(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "serviceRegistrationId" in path,
        "`serviceRegistrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/serviceHealths/"),
               (kind: VariableSegment, value: "serviceRegistrationId"),
               (kind: ConstantSegment, value: "/resourceHealths")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceHealthsList_574681(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns a list of each resource's health under a service.
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
  ##   serviceRegistrationId: JString (required)
  ##                        : Service registration ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574843 = path.getOrDefault("resourceGroupName")
  valid_574843 = validateParameter(valid_574843, JString, required = true,
                                 default = nil)
  if valid_574843 != nil:
    section.add "resourceGroupName", valid_574843
  var valid_574844 = path.getOrDefault("subscriptionId")
  valid_574844 = validateParameter(valid_574844, JString, required = true,
                                 default = nil)
  if valid_574844 != nil:
    section.add "subscriptionId", valid_574844
  var valid_574845 = path.getOrDefault("location")
  valid_574845 = validateParameter(valid_574845, JString, required = true,
                                 default = nil)
  if valid_574845 != nil:
    section.add "location", valid_574845
  var valid_574846 = path.getOrDefault("serviceRegistrationId")
  valid_574846 = validateParameter(valid_574846, JString, required = true,
                                 default = nil)
  if valid_574846 != nil:
    section.add "serviceRegistrationId", valid_574846
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574860 = query.getOrDefault("api-version")
  valid_574860 = validateParameter(valid_574860, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_574860 != nil:
    section.add "api-version", valid_574860
  var valid_574861 = query.getOrDefault("$filter")
  valid_574861 = validateParameter(valid_574861, JString, required = false,
                                 default = nil)
  if valid_574861 != nil:
    section.add "$filter", valid_574861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574888: Call_ResourceHealthsList_574680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of each resource's health under a service.
  ## 
  let valid = call_574888.validator(path, query, header, formData, body)
  let scheme = call_574888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574888.url(scheme.get, call_574888.host, call_574888.base,
                         call_574888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574888, url, valid)

proc call*(call_574959: Call_ResourceHealthsList_574680; resourceGroupName: string;
          subscriptionId: string; location: string; serviceRegistrationId: string;
          apiVersion: string = "2016-05-01"; Filter: string = ""): Recallable =
  ## resourceHealthsList
  ## Returns a list of each resource's health under a service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the region
  ##   serviceRegistrationId: string (required)
  ##                        : Service registration ID.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_574960 = newJObject()
  var query_574962 = newJObject()
  add(path_574960, "resourceGroupName", newJString(resourceGroupName))
  add(query_574962, "api-version", newJString(apiVersion))
  add(path_574960, "subscriptionId", newJString(subscriptionId))
  add(path_574960, "location", newJString(location))
  add(path_574960, "serviceRegistrationId", newJString(serviceRegistrationId))
  add(query_574962, "$filter", newJString(Filter))
  result = call_574959.call(path_574960, query_574962, nil, nil, nil)

var resourceHealthsList* = Call_ResourceHealthsList_574680(
    name: "resourceHealthsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/serviceHealths/{serviceRegistrationId}/resourceHealths",
    validator: validate_ResourceHealthsList_574681, base: "",
    url: url_ResourceHealthsList_574682, schemes: {Scheme.Https})
type
  Call_ResourceHealthsGet_575001 = ref object of OpenApiRestCall_574458
proc url_ResourceHealthsGet_575003(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "serviceRegistrationId" in path,
        "`serviceRegistrationId` is a required path parameter"
  assert "resourceRegistrationId" in path,
        "`resourceRegistrationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/serviceHealths/"),
               (kind: VariableSegment, value: "serviceRegistrationId"),
               (kind: ConstantSegment, value: "/resourceHealths/"),
               (kind: VariableSegment, value: "resourceRegistrationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceHealthsGet_575002(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the requested health information about a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   resourceRegistrationId: JString (required)
  ##                         : Resource registration ID.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Name of the region
  ##   serviceRegistrationId: JString (required)
  ##                        : Service registration ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575004 = path.getOrDefault("resourceGroupName")
  valid_575004 = validateParameter(valid_575004, JString, required = true,
                                 default = nil)
  if valid_575004 != nil:
    section.add "resourceGroupName", valid_575004
  var valid_575005 = path.getOrDefault("resourceRegistrationId")
  valid_575005 = validateParameter(valid_575005, JString, required = true,
                                 default = nil)
  if valid_575005 != nil:
    section.add "resourceRegistrationId", valid_575005
  var valid_575006 = path.getOrDefault("subscriptionId")
  valid_575006 = validateParameter(valid_575006, JString, required = true,
                                 default = nil)
  if valid_575006 != nil:
    section.add "subscriptionId", valid_575006
  var valid_575007 = path.getOrDefault("location")
  valid_575007 = validateParameter(valid_575007, JString, required = true,
                                 default = nil)
  if valid_575007 != nil:
    section.add "location", valid_575007
  var valid_575008 = path.getOrDefault("serviceRegistrationId")
  valid_575008 = validateParameter(valid_575008, JString, required = true,
                                 default = nil)
  if valid_575008 != nil:
    section.add "serviceRegistrationId", valid_575008
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575009 = query.getOrDefault("api-version")
  valid_575009 = validateParameter(valid_575009, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_575009 != nil:
    section.add "api-version", valid_575009
  var valid_575010 = query.getOrDefault("$filter")
  valid_575010 = validateParameter(valid_575010, JString, required = false,
                                 default = nil)
  if valid_575010 != nil:
    section.add "$filter", valid_575010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575011: Call_ResourceHealthsGet_575001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested health information about a resource.
  ## 
  let valid = call_575011.validator(path, query, header, formData, body)
  let scheme = call_575011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575011.url(scheme.get, call_575011.host, call_575011.base,
                         call_575011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575011, url, valid)

proc call*(call_575012: Call_ResourceHealthsGet_575001; resourceGroupName: string;
          resourceRegistrationId: string; subscriptionId: string; location: string;
          serviceRegistrationId: string; apiVersion: string = "2016-05-01";
          Filter: string = ""): Recallable =
  ## resourceHealthsGet
  ## Returns the requested health information about a resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   resourceRegistrationId: string (required)
  ##                         : Resource registration ID.
  ##   apiVersion: string (required)
  ##             : Client API Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: string (required)
  ##           : Name of the region
  ##   serviceRegistrationId: string (required)
  ##                        : Service registration ID.
  ##   Filter: string
  ##         : OData filter parameter.
  var path_575013 = newJObject()
  var query_575014 = newJObject()
  add(path_575013, "resourceGroupName", newJString(resourceGroupName))
  add(path_575013, "resourceRegistrationId", newJString(resourceRegistrationId))
  add(query_575014, "api-version", newJString(apiVersion))
  add(path_575013, "subscriptionId", newJString(subscriptionId))
  add(path_575013, "location", newJString(location))
  add(path_575013, "serviceRegistrationId", newJString(serviceRegistrationId))
  add(query_575014, "$filter", newJString(Filter))
  result = call_575012.call(path_575013, query_575014, nil, nil, nil)

var resourceHealthsGet* = Call_ResourceHealthsGet_575001(
    name: "resourceHealthsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/serviceHealths/{serviceRegistrationId}/resourceHealths/{resourceRegistrationId}",
    validator: validate_ResourceHealthsGet_575002, base: "",
    url: url_ResourceHealthsGet_575003, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

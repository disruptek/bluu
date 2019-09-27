
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_ResourceHealthsList_593647 = ref object of OpenApiRestCall_593425
proc url_ResourceHealthsList_593649(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceHealthsList_593648(path: JsonNode; query: JsonNode;
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
  var valid_593810 = path.getOrDefault("resourceGroupName")
  valid_593810 = validateParameter(valid_593810, JString, required = true,
                                 default = nil)
  if valid_593810 != nil:
    section.add "resourceGroupName", valid_593810
  var valid_593811 = path.getOrDefault("subscriptionId")
  valid_593811 = validateParameter(valid_593811, JString, required = true,
                                 default = nil)
  if valid_593811 != nil:
    section.add "subscriptionId", valid_593811
  var valid_593812 = path.getOrDefault("location")
  valid_593812 = validateParameter(valid_593812, JString, required = true,
                                 default = nil)
  if valid_593812 != nil:
    section.add "location", valid_593812
  var valid_593813 = path.getOrDefault("serviceRegistrationId")
  valid_593813 = validateParameter(valid_593813, JString, required = true,
                                 default = nil)
  if valid_593813 != nil:
    section.add "serviceRegistrationId", valid_593813
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593827 = query.getOrDefault("api-version")
  valid_593827 = validateParameter(valid_593827, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593827 != nil:
    section.add "api-version", valid_593827
  var valid_593828 = query.getOrDefault("$filter")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "$filter", valid_593828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593855: Call_ResourceHealthsList_593647; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a list of each resource's health under a service.
  ## 
  let valid = call_593855.validator(path, query, header, formData, body)
  let scheme = call_593855.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593855.url(scheme.get, call_593855.host, call_593855.base,
                         call_593855.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593855, url, valid)

proc call*(call_593926: Call_ResourceHealthsList_593647; resourceGroupName: string;
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
  var path_593927 = newJObject()
  var query_593929 = newJObject()
  add(path_593927, "resourceGroupName", newJString(resourceGroupName))
  add(query_593929, "api-version", newJString(apiVersion))
  add(path_593927, "subscriptionId", newJString(subscriptionId))
  add(path_593927, "location", newJString(location))
  add(path_593927, "serviceRegistrationId", newJString(serviceRegistrationId))
  add(query_593929, "$filter", newJString(Filter))
  result = call_593926.call(path_593927, query_593929, nil, nil, nil)

var resourceHealthsList* = Call_ResourceHealthsList_593647(
    name: "resourceHealthsList", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/serviceHealths/{serviceRegistrationId}/resourceHealths",
    validator: validate_ResourceHealthsList_593648, base: "",
    url: url_ResourceHealthsList_593649, schemes: {Scheme.Https})
type
  Call_ResourceHealthsGet_593968 = ref object of OpenApiRestCall_593425
proc url_ResourceHealthsGet_593970(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceHealthsGet_593969(path: JsonNode; query: JsonNode;
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
  var valid_593971 = path.getOrDefault("resourceGroupName")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "resourceGroupName", valid_593971
  var valid_593972 = path.getOrDefault("resourceRegistrationId")
  valid_593972 = validateParameter(valid_593972, JString, required = true,
                                 default = nil)
  if valid_593972 != nil:
    section.add "resourceRegistrationId", valid_593972
  var valid_593973 = path.getOrDefault("subscriptionId")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = nil)
  if valid_593973 != nil:
    section.add "subscriptionId", valid_593973
  var valid_593974 = path.getOrDefault("location")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = nil)
  if valid_593974 != nil:
    section.add "location", valid_593974
  var valid_593975 = path.getOrDefault("serviceRegistrationId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "serviceRegistrationId", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API Version.
  ##   $filter: JString
  ##          : OData filter parameter.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593976 = query.getOrDefault("api-version")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = newJString("2016-05-01"))
  if valid_593976 != nil:
    section.add "api-version", valid_593976
  var valid_593977 = query.getOrDefault("$filter")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "$filter", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_ResourceHealthsGet_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the requested health information about a resource.
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_ResourceHealthsGet_593968; resourceGroupName: string;
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
  var path_593980 = newJObject()
  var query_593981 = newJObject()
  add(path_593980, "resourceGroupName", newJString(resourceGroupName))
  add(path_593980, "resourceRegistrationId", newJString(resourceRegistrationId))
  add(query_593981, "api-version", newJString(apiVersion))
  add(path_593980, "subscriptionId", newJString(subscriptionId))
  add(path_593980, "location", newJString(location))
  add(path_593980, "serviceRegistrationId", newJString(serviceRegistrationId))
  add(query_593981, "$filter", newJString(Filter))
  result = call_593979.call(path_593980, query_593981, nil, nil, nil)

var resourceHealthsGet* = Call_ResourceHealthsGet_593968(
    name: "resourceHealthsGet", meth: HttpMethod.HttpGet,
    host: "adminmanagement.local.azurestack.external", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.InfrastructureInsights.Admin/regionHealths/{location}/serviceHealths/{serviceRegistrationId}/resourceHealths/{resourceRegistrationId}",
    validator: validate_ResourceHealthsGet_593969, base: "",
    url: url_ResourceHealthsGet_593970, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

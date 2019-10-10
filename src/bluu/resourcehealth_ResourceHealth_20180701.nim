
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Microsoft.ResourceHealth
## version: 2018-07-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Resource Health Client.
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "resourcehealth-ResourceHealth"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists available operations for the resourcehealth resource provider
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574040 = query.getOrDefault("api-version")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "api-version", valid_574040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574063: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the resourcehealth resource provider
  ## 
  let valid = call_574063.validator(path, query, header, formData, body)
  let scheme = call_574063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574063.url(scheme.get, call_574063.host, call_574063.base,
                         call_574063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574063, url, valid)

proc call*(call_574134: Call_OperationsList_573879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the resourcehealth resource provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574135 = newJObject()
  add(query_574135, "api-version", newJString(apiVersion))
  result = call_574134.call(nil, query_574135, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceHealth/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListBySubscriptionId_574175 = ref object of OpenApiRestCall_573657
proc url_AvailabilityStatusesListBySubscriptionId_574177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceHealth/availabilityStatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityStatusesListBySubscriptionId_574176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the current availability status for all the resources in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574193 = path.getOrDefault("subscriptionId")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "subscriptionId", valid_574193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574194 = query.getOrDefault("api-version")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "api-version", valid_574194
  var valid_574195 = query.getOrDefault("$expand")
  valid_574195 = validateParameter(valid_574195, JString, required = false,
                                 default = nil)
  if valid_574195 != nil:
    section.add "$expand", valid_574195
  var valid_574196 = query.getOrDefault("$filter")
  valid_574196 = validateParameter(valid_574196, JString, required = false,
                                 default = nil)
  if valid_574196 != nil:
    section.add "$filter", valid_574196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574197: Call_AvailabilityStatusesListBySubscriptionId_574175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the subscription.
  ## 
  let valid = call_574197.validator(path, query, header, formData, body)
  let scheme = call_574197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574197.url(scheme.get, call_574197.host, call_574197.base,
                         call_574197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574197, url, valid)

proc call*(call_574198: Call_AvailabilityStatusesListBySubscriptionId_574175;
          apiVersion: string; subscriptionId: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## availabilityStatusesListBySubscriptionId
  ## Lists the current availability status for all the resources in the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574199 = newJObject()
  var query_574200 = newJObject()
  add(query_574200, "api-version", newJString(apiVersion))
  add(query_574200, "$expand", newJString(Expand))
  add(path_574199, "subscriptionId", newJString(subscriptionId))
  add(query_574200, "$filter", newJString(Filter))
  result = call_574198.call(path_574199, query_574200, nil, nil, nil)

var availabilityStatusesListBySubscriptionId* = Call_AvailabilityStatusesListBySubscriptionId_574175(
    name: "availabilityStatusesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListBySubscriptionId_574176, base: "",
    url: url_AvailabilityStatusesListBySubscriptionId_574177,
    schemes: {Scheme.Https})
type
  Call_EventsListBySubscriptionId_574201 = ref object of OpenApiRestCall_573657
proc url_EventsListBySubscriptionId_574203(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ResourceHealth/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsListBySubscriptionId_574202(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists current service health events in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574204 = path.getOrDefault("subscriptionId")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "subscriptionId", valid_574204
  result.add "path", section
  ## parameters in `query` object:
  ##   view: JString
  ##       : setting view=full expands the article parameters
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  var valid_574205 = query.getOrDefault("view")
  valid_574205 = validateParameter(valid_574205, JString, required = false,
                                 default = nil)
  if valid_574205 != nil:
    section.add "view", valid_574205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  var valid_574207 = query.getOrDefault("$filter")
  valid_574207 = validateParameter(valid_574207, JString, required = false,
                                 default = nil)
  if valid_574207 != nil:
    section.add "$filter", valid_574207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574208: Call_EventsListBySubscriptionId_574201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists current service health events in the subscription.
  ## 
  let valid = call_574208.validator(path, query, header, formData, body)
  let scheme = call_574208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574208.url(scheme.get, call_574208.host, call_574208.base,
                         call_574208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574208, url, valid)

proc call*(call_574209: Call_EventsListBySubscriptionId_574201; apiVersion: string;
          subscriptionId: string; view: string = ""; Filter: string = ""): Recallable =
  ## eventsListBySubscriptionId
  ## Lists current service health events in the subscription.
  ##   view: string
  ##       : setting view=full expands the article parameters
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574210 = newJObject()
  var query_574211 = newJObject()
  add(query_574211, "view", newJString(view))
  add(query_574211, "api-version", newJString(apiVersion))
  add(path_574210, "subscriptionId", newJString(subscriptionId))
  add(query_574211, "$filter", newJString(Filter))
  result = call_574209.call(path_574210, query_574211, nil, nil, nil)

var eventsListBySubscriptionId* = Call_EventsListBySubscriptionId_574201(
    name: "eventsListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/events",
    validator: validate_EventsListBySubscriptionId_574202, base: "",
    url: url_EventsListBySubscriptionId_574203, schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListByResourceGroup_574212 = ref object of OpenApiRestCall_573657
proc url_AvailabilityStatusesListByResourceGroup_574214(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.ResourceHealth/availabilityStatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityStatusesListByResourceGroup_574213(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the current availability status for all the resources in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574215 = path.getOrDefault("resourceGroupName")
  valid_574215 = validateParameter(valid_574215, JString, required = true,
                                 default = nil)
  if valid_574215 != nil:
    section.add "resourceGroupName", valid_574215
  var valid_574216 = path.getOrDefault("subscriptionId")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "subscriptionId", valid_574216
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574217 = query.getOrDefault("api-version")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "api-version", valid_574217
  var valid_574218 = query.getOrDefault("$expand")
  valid_574218 = validateParameter(valid_574218, JString, required = false,
                                 default = nil)
  if valid_574218 != nil:
    section.add "$expand", valid_574218
  var valid_574219 = query.getOrDefault("$filter")
  valid_574219 = validateParameter(valid_574219, JString, required = false,
                                 default = nil)
  if valid_574219 != nil:
    section.add "$filter", valid_574219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574220: Call_AvailabilityStatusesListByResourceGroup_574212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the resource group.
  ## 
  let valid = call_574220.validator(path, query, header, formData, body)
  let scheme = call_574220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574220.url(scheme.get, call_574220.host, call_574220.base,
                         call_574220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574220, url, valid)

proc call*(call_574221: Call_AvailabilityStatusesListByResourceGroup_574212;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Filter: string = ""): Recallable =
  ## availabilityStatusesListByResourceGroup
  ## Lists the current availability status for all the resources in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574222 = newJObject()
  var query_574223 = newJObject()
  add(path_574222, "resourceGroupName", newJString(resourceGroupName))
  add(query_574223, "api-version", newJString(apiVersion))
  add(query_574223, "$expand", newJString(Expand))
  add(path_574222, "subscriptionId", newJString(subscriptionId))
  add(query_574223, "$filter", newJString(Filter))
  result = call_574221.call(path_574222, query_574223, nil, nil, nil)

var availabilityStatusesListByResourceGroup* = Call_AvailabilityStatusesListByResourceGroup_574212(
    name: "availabilityStatusesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListByResourceGroup_574213, base: "",
    url: url_AvailabilityStatusesListByResourceGroup_574214,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesList_574224 = ref object of OpenApiRestCall_573657
proc url_AvailabilityStatusesList_574226(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceHealth/availabilityStatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityStatusesList_574225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all historical availability transitions and impacting events for a single resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_574227 = path.getOrDefault("resourceUri")
  valid_574227 = validateParameter(valid_574227, JString, required = true,
                                 default = nil)
  if valid_574227 != nil:
    section.add "resourceUri", valid_574227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574228 = query.getOrDefault("api-version")
  valid_574228 = validateParameter(valid_574228, JString, required = true,
                                 default = nil)
  if valid_574228 != nil:
    section.add "api-version", valid_574228
  var valid_574229 = query.getOrDefault("$expand")
  valid_574229 = validateParameter(valid_574229, JString, required = false,
                                 default = nil)
  if valid_574229 != nil:
    section.add "$expand", valid_574229
  var valid_574230 = query.getOrDefault("$filter")
  valid_574230 = validateParameter(valid_574230, JString, required = false,
                                 default = nil)
  if valid_574230 != nil:
    section.add "$filter", valid_574230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574231: Call_AvailabilityStatusesList_574224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all historical availability transitions and impacting events for a single resource.
  ## 
  let valid = call_574231.validator(path, query, header, formData, body)
  let scheme = call_574231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574231.url(scheme.get, call_574231.host, call_574231.base,
                         call_574231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574231, url, valid)

proc call*(call_574232: Call_AvailabilityStatusesList_574224; apiVersion: string;
          resourceUri: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## availabilityStatusesList
  ## Lists all historical availability transitions and impacting events for a single resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574233 = newJObject()
  var query_574234 = newJObject()
  add(query_574234, "api-version", newJString(apiVersion))
  add(query_574234, "$expand", newJString(Expand))
  add(path_574233, "resourceUri", newJString(resourceUri))
  add(query_574234, "$filter", newJString(Filter))
  result = call_574232.call(path_574233, query_574234, nil, nil, nil)

var availabilityStatusesList* = Call_AvailabilityStatusesList_574224(
    name: "availabilityStatusesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesList_574225, base: "",
    url: url_AvailabilityStatusesList_574226, schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesGetByResource_574235 = ref object of OpenApiRestCall_573657
proc url_AvailabilityStatusesGetByResource_574237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ResourceHealth/availabilityStatuses/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AvailabilityStatusesGetByResource_574236(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets current availability status for a single resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_574238 = path.getOrDefault("resourceUri")
  valid_574238 = validateParameter(valid_574238, JString, required = true,
                                 default = nil)
  if valid_574238 != nil:
    section.add "resourceUri", valid_574238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574239 = query.getOrDefault("api-version")
  valid_574239 = validateParameter(valid_574239, JString, required = true,
                                 default = nil)
  if valid_574239 != nil:
    section.add "api-version", valid_574239
  var valid_574240 = query.getOrDefault("$expand")
  valid_574240 = validateParameter(valid_574240, JString, required = false,
                                 default = nil)
  if valid_574240 != nil:
    section.add "$expand", valid_574240
  var valid_574241 = query.getOrDefault("$filter")
  valid_574241 = validateParameter(valid_574241, JString, required = false,
                                 default = nil)
  if valid_574241 != nil:
    section.add "$filter", valid_574241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574242: Call_AvailabilityStatusesGetByResource_574235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets current availability status for a single resource
  ## 
  let valid = call_574242.validator(path, query, header, formData, body)
  let scheme = call_574242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574242.url(scheme.get, call_574242.host, call_574242.base,
                         call_574242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574242, url, valid)

proc call*(call_574243: Call_AvailabilityStatusesGetByResource_574235;
          apiVersion: string; resourceUri: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## availabilityStatusesGetByResource
  ## Gets current availability status for a single resource
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574244 = newJObject()
  var query_574245 = newJObject()
  add(query_574245, "api-version", newJString(apiVersion))
  add(query_574245, "$expand", newJString(Expand))
  add(path_574244, "resourceUri", newJString(resourceUri))
  add(query_574245, "$filter", newJString(Filter))
  result = call_574243.call(path_574244, query_574245, nil, nil, nil)

var availabilityStatusesGetByResource* = Call_AvailabilityStatusesGetByResource_574235(
    name: "availabilityStatusesGetByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses/current",
    validator: validate_AvailabilityStatusesGetByResource_574236, base: "",
    url: url_AvailabilityStatusesGetByResource_574237, schemes: {Scheme.Https})
type
  Call_EventsListBySingleResource_574246 = ref object of OpenApiRestCall_573657
proc url_EventsListBySingleResource_574248(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ResourceHealth/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsListBySingleResource_574247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists current service health events for given resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_574249 = path.getOrDefault("resourceUri")
  valid_574249 = validateParameter(valid_574249, JString, required = true,
                                 default = nil)
  if valid_574249 != nil:
    section.add "resourceUri", valid_574249
  result.add "path", section
  ## parameters in `query` object:
  ##   view: JString
  ##       : setting view=full expands the article parameters
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  var valid_574250 = query.getOrDefault("view")
  valid_574250 = validateParameter(valid_574250, JString, required = false,
                                 default = nil)
  if valid_574250 != nil:
    section.add "view", valid_574250
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574251 = query.getOrDefault("api-version")
  valid_574251 = validateParameter(valid_574251, JString, required = true,
                                 default = nil)
  if valid_574251 != nil:
    section.add "api-version", valid_574251
  var valid_574252 = query.getOrDefault("$filter")
  valid_574252 = validateParameter(valid_574252, JString, required = false,
                                 default = nil)
  if valid_574252 != nil:
    section.add "$filter", valid_574252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574253: Call_EventsListBySingleResource_574246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists current service health events for given resource.
  ## 
  let valid = call_574253.validator(path, query, header, formData, body)
  let scheme = call_574253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574253.url(scheme.get, call_574253.host, call_574253.base,
                         call_574253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574253, url, valid)

proc call*(call_574254: Call_EventsListBySingleResource_574246; apiVersion: string;
          resourceUri: string; view: string = ""; Filter: string = ""): Recallable =
  ## eventsListBySingleResource
  ## Lists current service health events for given resource.
  ##   view: string
  ##       : setting view=full expands the article parameters
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574255 = newJObject()
  var query_574256 = newJObject()
  add(query_574256, "view", newJString(view))
  add(query_574256, "api-version", newJString(apiVersion))
  add(path_574255, "resourceUri", newJString(resourceUri))
  add(query_574256, "$filter", newJString(Filter))
  result = call_574254.call(path_574255, query_574256, nil, nil, nil)

var eventsListBySingleResource* = Call_EventsListBySingleResource_574246(
    name: "eventsListBySingleResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceUri}/providers/Microsoft.ResourceHealth/events",
    validator: validate_EventsListBySingleResource_574247, base: "",
    url: url_EventsListBySingleResource_574248, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

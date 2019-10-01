
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Microsoft.ResourceHealth
## version: 2017-07-01
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "resourcehealth"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
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
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the resourcehealth resource provider
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the resourcehealth resource provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceHealth/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListBySubscriptionId_568159 = ref object of OpenApiRestCall_567641
proc url_AvailabilityStatusesListBySubscriptionId_568161(protocol: Scheme;
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

proc validate_AvailabilityStatusesListBySubscriptionId_568160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the current availability status for all the resources in the subscription. Use the nextLink property in the response to get the next page of availability statuses.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568177 = path.getOrDefault("subscriptionId")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "subscriptionId", valid_568177
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
  var valid_568178 = query.getOrDefault("api-version")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "api-version", valid_568178
  var valid_568179 = query.getOrDefault("$expand")
  valid_568179 = validateParameter(valid_568179, JString, required = false,
                                 default = nil)
  if valid_568179 != nil:
    section.add "$expand", valid_568179
  var valid_568180 = query.getOrDefault("$filter")
  valid_568180 = validateParameter(valid_568180, JString, required = false,
                                 default = nil)
  if valid_568180 != nil:
    section.add "$filter", valid_568180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_AvailabilityStatusesListBySubscriptionId_568159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the subscription. Use the nextLink property in the response to get the next page of availability statuses.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_AvailabilityStatusesListBySubscriptionId_568159;
          apiVersion: string; subscriptionId: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## availabilityStatusesListBySubscriptionId
  ## Lists the current availability status for all the resources in the subscription. Use the nextLink property in the response to get the next page of availability statuses.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  add(query_568184, "api-version", newJString(apiVersion))
  add(query_568184, "$expand", newJString(Expand))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  add(query_568184, "$filter", newJString(Filter))
  result = call_568182.call(path_568183, query_568184, nil, nil, nil)

var availabilityStatusesListBySubscriptionId* = Call_AvailabilityStatusesListBySubscriptionId_568159(
    name: "availabilityStatusesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListBySubscriptionId_568160, base: "",
    url: url_AvailabilityStatusesListBySubscriptionId_568161,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListByResourceGroup_568185 = ref object of OpenApiRestCall_567641
proc url_AvailabilityStatusesListByResourceGroup_568187(protocol: Scheme;
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

proc validate_AvailabilityStatusesListByResourceGroup_568186(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the current availability status for all the resources in the resource group. Use the nextLink property in the response to get the next page of availability statuses.
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
  var valid_568188 = path.getOrDefault("resourceGroupName")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "resourceGroupName", valid_568188
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
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
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  var valid_568191 = query.getOrDefault("$expand")
  valid_568191 = validateParameter(valid_568191, JString, required = false,
                                 default = nil)
  if valid_568191 != nil:
    section.add "$expand", valid_568191
  var valid_568192 = query.getOrDefault("$filter")
  valid_568192 = validateParameter(valid_568192, JString, required = false,
                                 default = nil)
  if valid_568192 != nil:
    section.add "$filter", valid_568192
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568193: Call_AvailabilityStatusesListByResourceGroup_568185;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the resource group. Use the nextLink property in the response to get the next page of availability statuses.
  ## 
  let valid = call_568193.validator(path, query, header, formData, body)
  let scheme = call_568193.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568193.url(scheme.get, call_568193.host, call_568193.base,
                         call_568193.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568193, url, valid)

proc call*(call_568194: Call_AvailabilityStatusesListByResourceGroup_568185;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Filter: string = ""): Recallable =
  ## availabilityStatusesListByResourceGroup
  ## Lists the current availability status for all the resources in the resource group. Use the nextLink property in the response to get the next page of availability statuses.
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
  var path_568195 = newJObject()
  var query_568196 = newJObject()
  add(path_568195, "resourceGroupName", newJString(resourceGroupName))
  add(query_568196, "api-version", newJString(apiVersion))
  add(query_568196, "$expand", newJString(Expand))
  add(path_568195, "subscriptionId", newJString(subscriptionId))
  add(query_568196, "$filter", newJString(Filter))
  result = call_568194.call(path_568195, query_568196, nil, nil, nil)

var availabilityStatusesListByResourceGroup* = Call_AvailabilityStatusesListByResourceGroup_568185(
    name: "availabilityStatusesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListByResourceGroup_568186, base: "",
    url: url_AvailabilityStatusesListByResourceGroup_568187,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesList_568197 = ref object of OpenApiRestCall_567641
proc url_AvailabilityStatusesList_568199(protocol: Scheme; host: string;
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

proc validate_AvailabilityStatusesList_568198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all historical availability transitions and impacting events for a single resource. Use the nextLink property in the response to get the next page of availability status
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
  var valid_568200 = path.getOrDefault("resourceUri")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "resourceUri", valid_568200
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
  var valid_568201 = query.getOrDefault("api-version")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "api-version", valid_568201
  var valid_568202 = query.getOrDefault("$expand")
  valid_568202 = validateParameter(valid_568202, JString, required = false,
                                 default = nil)
  if valid_568202 != nil:
    section.add "$expand", valid_568202
  var valid_568203 = query.getOrDefault("$filter")
  valid_568203 = validateParameter(valid_568203, JString, required = false,
                                 default = nil)
  if valid_568203 != nil:
    section.add "$filter", valid_568203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568204: Call_AvailabilityStatusesList_568197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all historical availability transitions and impacting events for a single resource. Use the nextLink property in the response to get the next page of availability status
  ## 
  let valid = call_568204.validator(path, query, header, formData, body)
  let scheme = call_568204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568204.url(scheme.get, call_568204.host, call_568204.base,
                         call_568204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568204, url, valid)

proc call*(call_568205: Call_AvailabilityStatusesList_568197; apiVersion: string;
          resourceUri: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## availabilityStatusesList
  ## Lists all historical availability transitions and impacting events for a single resource. Use the nextLink property in the response to get the next page of availability status
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
  var path_568206 = newJObject()
  var query_568207 = newJObject()
  add(query_568207, "api-version", newJString(apiVersion))
  add(query_568207, "$expand", newJString(Expand))
  add(path_568206, "resourceUri", newJString(resourceUri))
  add(query_568207, "$filter", newJString(Filter))
  result = call_568205.call(path_568206, query_568207, nil, nil, nil)

var availabilityStatusesList* = Call_AvailabilityStatusesList_568197(
    name: "availabilityStatusesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesList_568198, base: "",
    url: url_AvailabilityStatusesList_568199, schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesGetByResource_568208 = ref object of OpenApiRestCall_567641
proc url_AvailabilityStatusesGetByResource_568210(protocol: Scheme; host: string;
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

proc validate_AvailabilityStatusesGetByResource_568209(path: JsonNode;
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
  var valid_568211 = path.getOrDefault("resourceUri")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "resourceUri", valid_568211
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
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  var valid_568213 = query.getOrDefault("$expand")
  valid_568213 = validateParameter(valid_568213, JString, required = false,
                                 default = nil)
  if valid_568213 != nil:
    section.add "$expand", valid_568213
  var valid_568214 = query.getOrDefault("$filter")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "$filter", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_AvailabilityStatusesGetByResource_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets current availability status for a single resource
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_AvailabilityStatusesGetByResource_568208;
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
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(query_568218, "api-version", newJString(apiVersion))
  add(query_568218, "$expand", newJString(Expand))
  add(path_568217, "resourceUri", newJString(resourceUri))
  add(query_568218, "$filter", newJString(Filter))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var availabilityStatusesGetByResource* = Call_AvailabilityStatusesGetByResource_568208(
    name: "availabilityStatusesGetByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses/current",
    validator: validate_AvailabilityStatusesGetByResource_568209, base: "",
    url: url_AvailabilityStatusesGetByResource_568210, schemes: {Scheme.Https})
type
  Call_ChildAvailabilityStatusesList_568219 = ref object of OpenApiRestCall_567641
proc url_ChildAvailabilityStatusesList_568221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceHealth/childAvailabilityStatuses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChildAvailabilityStatusesList_568220(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the historical availability statuses for a single child resource. Use the nextLink property in the response to get the next page of availability status
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API only support one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568222 = path.getOrDefault("resourceUri")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "resourceUri", valid_568222
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
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  var valid_568224 = query.getOrDefault("$expand")
  valid_568224 = validateParameter(valid_568224, JString, required = false,
                                 default = nil)
  if valid_568224 != nil:
    section.add "$expand", valid_568224
  var valid_568225 = query.getOrDefault("$filter")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "$filter", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_ChildAvailabilityStatusesList_568219; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the historical availability statuses for a single child resource. Use the nextLink property in the response to get the next page of availability status
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_ChildAvailabilityStatusesList_568219;
          apiVersion: string; resourceUri: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## childAvailabilityStatusesList
  ## Lists the historical availability statuses for a single child resource. Use the nextLink property in the response to get the next page of availability status
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API only support one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(query_568229, "$expand", newJString(Expand))
  add(path_568228, "resourceUri", newJString(resourceUri))
  add(query_568229, "$filter", newJString(Filter))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var childAvailabilityStatusesList* = Call_ChildAvailabilityStatusesList_568219(
    name: "childAvailabilityStatusesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/childAvailabilityStatuses",
    validator: validate_ChildAvailabilityStatusesList_568220, base: "",
    url: url_ChildAvailabilityStatusesList_568221, schemes: {Scheme.Https})
type
  Call_ChildAvailabilityStatusesGetByResource_568230 = ref object of OpenApiRestCall_567641
proc url_ChildAvailabilityStatusesGetByResource_568232(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/Microsoft.ResourceHealth/childAvailabilityStatuses/current")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChildAvailabilityStatusesGetByResource_568231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets current availability status for a single resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API only support one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568233 = path.getOrDefault("resourceUri")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "resourceUri", valid_568233
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
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  var valid_568235 = query.getOrDefault("$expand")
  valid_568235 = validateParameter(valid_568235, JString, required = false,
                                 default = nil)
  if valid_568235 != nil:
    section.add "$expand", valid_568235
  var valid_568236 = query.getOrDefault("$filter")
  valid_568236 = validateParameter(valid_568236, JString, required = false,
                                 default = nil)
  if valid_568236 != nil:
    section.add "$filter", valid_568236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568237: Call_ChildAvailabilityStatusesGetByResource_568230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets current availability status for a single resource
  ## 
  let valid = call_568237.validator(path, query, header, formData, body)
  let scheme = call_568237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568237.url(scheme.get, call_568237.host, call_568237.base,
                         call_568237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568237, url, valid)

proc call*(call_568238: Call_ChildAvailabilityStatusesGetByResource_568230;
          apiVersion: string; resourceUri: string; Expand: string = "";
          Filter: string = ""): Recallable =
  ## childAvailabilityStatusesGetByResource
  ## Gets current availability status for a single resource
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API only support one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_568239 = newJObject()
  var query_568240 = newJObject()
  add(query_568240, "api-version", newJString(apiVersion))
  add(query_568240, "$expand", newJString(Expand))
  add(path_568239, "resourceUri", newJString(resourceUri))
  add(query_568240, "$filter", newJString(Filter))
  result = call_568238.call(path_568239, query_568240, nil, nil, nil)

var childAvailabilityStatusesGetByResource* = Call_ChildAvailabilityStatusesGetByResource_568230(
    name: "childAvailabilityStatusesGetByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/childAvailabilityStatuses/current",
    validator: validate_ChildAvailabilityStatusesGetByResource_568231, base: "",
    url: url_ChildAvailabilityStatusesGetByResource_568232,
    schemes: {Scheme.Https})
type
  Call_ChildResourcesList_568241 = ref object of OpenApiRestCall_567641
proc url_ChildResourcesList_568243(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ResourceHealth/childResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ChildResourcesList_568242(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the all the children and its current health status for a parent resource. Use the nextLink property in the response to get the next page of children current health
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API only support not nested parent resource type: 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_568244 = path.getOrDefault("resourceUri")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceUri", valid_568244
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
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  var valid_568246 = query.getOrDefault("$expand")
  valid_568246 = validateParameter(valid_568246, JString, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "$expand", valid_568246
  var valid_568247 = query.getOrDefault("$filter")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "$filter", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_ChildResourcesList_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the all the children and its current health status for a parent resource. Use the nextLink property in the response to get the next page of children current health
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_ChildResourcesList_568241; apiVersion: string;
          resourceUri: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## childResourcesList
  ## Lists the all the children and its current health status for a parent resource. Use the nextLink property in the response to get the next page of children current health
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : Setting $expand=recommendedactions in url query expands the recommendedactions in the response.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API only support not nested parent resource type: 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(query_568251, "api-version", newJString(apiVersion))
  add(query_568251, "$expand", newJString(Expand))
  add(path_568250, "resourceUri", newJString(resourceUri))
  add(query_568251, "$filter", newJString(Filter))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var childResourcesList* = Call_ChildResourcesList_568241(
    name: "childResourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceUri}/providers/Microsoft.ResourceHealth/childResources",
    validator: validate_ChildResourcesList_568242, base: "",
    url: url_ChildResourcesList_568243, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)


import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Microsoft.ResourceHealth
## version: 2015-01-01
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
  macServiceName = "resourcehealth"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593630 = ref object of OpenApiRestCall_593408
proc url_OperationsList_593632(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593631(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("api-version")
  valid_593791 = validateParameter(valid_593791, JString, required = true,
                                 default = nil)
  if valid_593791 != nil:
    section.add "api-version", valid_593791
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593814: Call_OperationsList_593630; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the resourcehealth resource provider
  ## 
  let valid = call_593814.validator(path, query, header, formData, body)
  let scheme = call_593814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593814.url(scheme.get, call_593814.host, call_593814.base,
                         call_593814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593814, url, valid)

proc call*(call_593885: Call_OperationsList_593630; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the resourcehealth resource provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593886 = newJObject()
  add(query_593886, "api-version", newJString(apiVersion))
  result = call_593885.call(nil, query_593886, nil, nil, nil)

var operationsList* = Call_OperationsList_593630(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceHealth/operations",
    validator: validate_OperationsList_593631, base: "", url: url_OperationsList_593632,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListBySubscriptionId_593926 = ref object of OpenApiRestCall_593408
proc url_AvailabilityStatusesListBySubscriptionId_593928(protocol: Scheme;
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

proc validate_AvailabilityStatusesListBySubscriptionId_593927(path: JsonNode;
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
  var valid_593944 = path.getOrDefault("subscriptionId")
  valid_593944 = validateParameter(valid_593944, JString, required = true,
                                 default = nil)
  if valid_593944 != nil:
    section.add "subscriptionId", valid_593944
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
  var valid_593945 = query.getOrDefault("api-version")
  valid_593945 = validateParameter(valid_593945, JString, required = true,
                                 default = nil)
  if valid_593945 != nil:
    section.add "api-version", valid_593945
  var valid_593946 = query.getOrDefault("$expand")
  valid_593946 = validateParameter(valid_593946, JString, required = false,
                                 default = nil)
  if valid_593946 != nil:
    section.add "$expand", valid_593946
  var valid_593947 = query.getOrDefault("$filter")
  valid_593947 = validateParameter(valid_593947, JString, required = false,
                                 default = nil)
  if valid_593947 != nil:
    section.add "$filter", valid_593947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593948: Call_AvailabilityStatusesListBySubscriptionId_593926;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the subscription. Use the nextLink property in the response to get the next page of availability statuses.
  ## 
  let valid = call_593948.validator(path, query, header, formData, body)
  let scheme = call_593948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593948.url(scheme.get, call_593948.host, call_593948.base,
                         call_593948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593948, url, valid)

proc call*(call_593949: Call_AvailabilityStatusesListBySubscriptionId_593926;
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
  var path_593950 = newJObject()
  var query_593951 = newJObject()
  add(query_593951, "api-version", newJString(apiVersion))
  add(query_593951, "$expand", newJString(Expand))
  add(path_593950, "subscriptionId", newJString(subscriptionId))
  add(query_593951, "$filter", newJString(Filter))
  result = call_593949.call(path_593950, query_593951, nil, nil, nil)

var availabilityStatusesListBySubscriptionId* = Call_AvailabilityStatusesListBySubscriptionId_593926(
    name: "availabilityStatusesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListBySubscriptionId_593927, base: "",
    url: url_AvailabilityStatusesListBySubscriptionId_593928,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListByResourceGroup_593952 = ref object of OpenApiRestCall_593408
proc url_AvailabilityStatusesListByResourceGroup_593954(protocol: Scheme;
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

proc validate_AvailabilityStatusesListByResourceGroup_593953(path: JsonNode;
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
  var valid_593955 = path.getOrDefault("resourceGroupName")
  valid_593955 = validateParameter(valid_593955, JString, required = true,
                                 default = nil)
  if valid_593955 != nil:
    section.add "resourceGroupName", valid_593955
  var valid_593956 = path.getOrDefault("subscriptionId")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "subscriptionId", valid_593956
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
  var valid_593957 = query.getOrDefault("api-version")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "api-version", valid_593957
  var valid_593958 = query.getOrDefault("$expand")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "$expand", valid_593958
  var valid_593959 = query.getOrDefault("$filter")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "$filter", valid_593959
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593960: Call_AvailabilityStatusesListByResourceGroup_593952;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the resource group. Use the nextLink property in the response to get the next page of availability statuses.
  ## 
  let valid = call_593960.validator(path, query, header, formData, body)
  let scheme = call_593960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593960.url(scheme.get, call_593960.host, call_593960.base,
                         call_593960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593960, url, valid)

proc call*(call_593961: Call_AvailabilityStatusesListByResourceGroup_593952;
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
  var path_593962 = newJObject()
  var query_593963 = newJObject()
  add(path_593962, "resourceGroupName", newJString(resourceGroupName))
  add(query_593963, "api-version", newJString(apiVersion))
  add(query_593963, "$expand", newJString(Expand))
  add(path_593962, "subscriptionId", newJString(subscriptionId))
  add(query_593963, "$filter", newJString(Filter))
  result = call_593961.call(path_593962, query_593963, nil, nil, nil)

var availabilityStatusesListByResourceGroup* = Call_AvailabilityStatusesListByResourceGroup_593952(
    name: "availabilityStatusesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListByResourceGroup_593953, base: "",
    url: url_AvailabilityStatusesListByResourceGroup_593954,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesList_593964 = ref object of OpenApiRestCall_593408
proc url_AvailabilityStatusesList_593966(protocol: Scheme; host: string;
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

proc validate_AvailabilityStatusesList_593965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the historical availability statuses for a single resource. Use the nextLink property in the response to get the next page of availability status
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
  var valid_593967 = path.getOrDefault("resourceUri")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "resourceUri", valid_593967
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
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  var valid_593969 = query.getOrDefault("$expand")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "$expand", valid_593969
  var valid_593970 = query.getOrDefault("$filter")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "$filter", valid_593970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593971: Call_AvailabilityStatusesList_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the historical availability statuses for a single resource. Use the nextLink property in the response to get the next page of availability status
  ## 
  let valid = call_593971.validator(path, query, header, formData, body)
  let scheme = call_593971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593971.url(scheme.get, call_593971.host, call_593971.base,
                         call_593971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593971, url, valid)

proc call*(call_593972: Call_AvailabilityStatusesList_593964; apiVersion: string;
          resourceUri: string; Expand: string = ""; Filter: string = ""): Recallable =
  ## availabilityStatusesList
  ## Lists the historical availability statuses for a single resource. Use the nextLink property in the response to get the next page of availability status
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
  var path_593973 = newJObject()
  var query_593974 = newJObject()
  add(query_593974, "api-version", newJString(apiVersion))
  add(query_593974, "$expand", newJString(Expand))
  add(path_593973, "resourceUri", newJString(resourceUri))
  add(query_593974, "$filter", newJString(Filter))
  result = call_593972.call(path_593973, query_593974, nil, nil, nil)

var availabilityStatusesList* = Call_AvailabilityStatusesList_593964(
    name: "availabilityStatusesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesList_593965, base: "",
    url: url_AvailabilityStatusesList_593966, schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesGetByResource_593975 = ref object of OpenApiRestCall_593408
proc url_AvailabilityStatusesGetByResource_593977(protocol: Scheme; host: string;
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

proc validate_AvailabilityStatusesGetByResource_593976(path: JsonNode;
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
  var valid_593978 = path.getOrDefault("resourceUri")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceUri", valid_593978
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
  var valid_593979 = query.getOrDefault("api-version")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "api-version", valid_593979
  var valid_593980 = query.getOrDefault("$expand")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "$expand", valid_593980
  var valid_593981 = query.getOrDefault("$filter")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "$filter", valid_593981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593982: Call_AvailabilityStatusesGetByResource_593975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets current availability status for a single resource
  ## 
  let valid = call_593982.validator(path, query, header, formData, body)
  let scheme = call_593982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593982.url(scheme.get, call_593982.host, call_593982.base,
                         call_593982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593982, url, valid)

proc call*(call_593983: Call_AvailabilityStatusesGetByResource_593975;
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
  var path_593984 = newJObject()
  var query_593985 = newJObject()
  add(query_593985, "api-version", newJString(apiVersion))
  add(query_593985, "$expand", newJString(Expand))
  add(path_593984, "resourceUri", newJString(resourceUri))
  add(query_593985, "$filter", newJString(Filter))
  result = call_593983.call(path_593984, query_593985, nil, nil, nil)

var availabilityStatusesGetByResource* = Call_AvailabilityStatusesGetByResource_593975(
    name: "availabilityStatusesGetByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses/current",
    validator: validate_AvailabilityStatusesGetByResource_593976, base: "",
    url: url_AvailabilityStatusesGetByResource_593977, schemes: {Scheme.Https})
type
  Call_ChildAvailabilityStatusesList_593986 = ref object of OpenApiRestCall_593408
proc url_ChildAvailabilityStatusesList_593988(protocol: Scheme; host: string;
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

proc validate_ChildAvailabilityStatusesList_593987(path: JsonNode; query: JsonNode;
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
  var valid_593989 = path.getOrDefault("resourceUri")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "resourceUri", valid_593989
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
  var valid_593990 = query.getOrDefault("api-version")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "api-version", valid_593990
  var valid_593991 = query.getOrDefault("$expand")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "$expand", valid_593991
  var valid_593992 = query.getOrDefault("$filter")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "$filter", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_ChildAvailabilityStatusesList_593986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the historical availability statuses for a single child resource. Use the nextLink property in the response to get the next page of availability status
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_ChildAvailabilityStatusesList_593986;
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
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "api-version", newJString(apiVersion))
  add(query_593996, "$expand", newJString(Expand))
  add(path_593995, "resourceUri", newJString(resourceUri))
  add(query_593996, "$filter", newJString(Filter))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var childAvailabilityStatusesList* = Call_ChildAvailabilityStatusesList_593986(
    name: "childAvailabilityStatusesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/childAvailabilityStatuses",
    validator: validate_ChildAvailabilityStatusesList_593987, base: "",
    url: url_ChildAvailabilityStatusesList_593988, schemes: {Scheme.Https})
type
  Call_ChildAvailabilityStatusesGetByResource_593997 = ref object of OpenApiRestCall_593408
proc url_ChildAvailabilityStatusesGetByResource_593999(protocol: Scheme;
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

proc validate_ChildAvailabilityStatusesGetByResource_593998(path: JsonNode;
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
  var valid_594000 = path.getOrDefault("resourceUri")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "resourceUri", valid_594000
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
  var valid_594001 = query.getOrDefault("api-version")
  valid_594001 = validateParameter(valid_594001, JString, required = true,
                                 default = nil)
  if valid_594001 != nil:
    section.add "api-version", valid_594001
  var valid_594002 = query.getOrDefault("$expand")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "$expand", valid_594002
  var valid_594003 = query.getOrDefault("$filter")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "$filter", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_ChildAvailabilityStatusesGetByResource_593997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets current availability status for a single resource
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_ChildAvailabilityStatusesGetByResource_593997;
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
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(query_594007, "$expand", newJString(Expand))
  add(path_594006, "resourceUri", newJString(resourceUri))
  add(query_594007, "$filter", newJString(Filter))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var childAvailabilityStatusesGetByResource* = Call_ChildAvailabilityStatusesGetByResource_593997(
    name: "childAvailabilityStatusesGetByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/childAvailabilityStatuses/current",
    validator: validate_ChildAvailabilityStatusesGetByResource_593998, base: "",
    url: url_ChildAvailabilityStatusesGetByResource_593999,
    schemes: {Scheme.Https})
type
  Call_ChildResourcesList_594008 = ref object of OpenApiRestCall_593408
proc url_ChildResourcesList_594010(protocol: Scheme; host: string; base: string;
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

proc validate_ChildResourcesList_594009(path: JsonNode; query: JsonNode;
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
  var valid_594011 = path.getOrDefault("resourceUri")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceUri", valid_594011
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
  var valid_594012 = query.getOrDefault("api-version")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "api-version", valid_594012
  var valid_594013 = query.getOrDefault("$expand")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "$expand", valid_594013
  var valid_594014 = query.getOrDefault("$filter")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "$filter", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_ChildResourcesList_594008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the all the children and its current health status for a parent resource. Use the nextLink property in the response to get the next page of children current health
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_ChildResourcesList_594008; apiVersion: string;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(query_594018, "api-version", newJString(apiVersion))
  add(query_594018, "$expand", newJString(Expand))
  add(path_594017, "resourceUri", newJString(resourceUri))
  add(query_594018, "$filter", newJString(Filter))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var childResourcesList* = Call_ChildResourcesList_594008(
    name: "childResourcesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceUri}/providers/Microsoft.ResourceHealth/childResources",
    validator: validate_ChildResourcesList_594009, base: "",
    url: url_ChildResourcesList_594010, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

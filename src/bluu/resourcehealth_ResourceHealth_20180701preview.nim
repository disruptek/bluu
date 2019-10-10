
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Microsoft.ResourceHealth
## version: 2018-07-01-preview
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

  OpenApiRestCall_573658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573658): Option[Scheme] {.used.} =
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
  Call_MetadataList_573880 = ref object of OpenApiRestCall_573658
proc url_MetadataList_573882(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_MetadataList_573881(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_574041 = query.getOrDefault("api-version")
  valid_574041 = validateParameter(valid_574041, JString, required = true,
                                 default = nil)
  if valid_574041 != nil:
    section.add "api-version", valid_574041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574064: Call_MetadataList_573880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574064.validator(path, query, header, formData, body)
  let scheme = call_574064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574064.url(scheme.get, call_574064.host, call_574064.base,
                         call_574064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574064, url, valid)

proc call*(call_574135: Call_MetadataList_573880; apiVersion: string): Recallable =
  ## metadataList
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574136 = newJObject()
  add(query_574136, "api-version", newJString(apiVersion))
  result = call_574135.call(nil, query_574136, nil, nil, nil)

var metadataList* = Call_MetadataList_573880(name: "metadataList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceHealth/metadata",
    validator: validate_MetadataList_573881, base: "", url: url_MetadataList_573882,
    schemes: {Scheme.Https})
type
  Call_MetadataGet_574176 = ref object of OpenApiRestCall_573658
proc url_MetadataGet_574178(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment,
                value: "/providers/Microsoft.ResourceHealth/metadata/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetadataGet_574177(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Name of metadata entity.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_574193 = path.getOrDefault("name")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "name", valid_574193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574194 = query.getOrDefault("api-version")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "api-version", valid_574194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574195: Call_MetadataGet_574176; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_574195.validator(path, query, header, formData, body)
  let scheme = call_574195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574195.url(scheme.get, call_574195.host, call_574195.base,
                         call_574195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574195, url, valid)

proc call*(call_574196: Call_MetadataGet_574176; apiVersion: string; name: string): Recallable =
  ## metadataGet
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : Name of metadata entity.
  var path_574197 = newJObject()
  var query_574198 = newJObject()
  add(query_574198, "api-version", newJString(apiVersion))
  add(path_574197, "name", newJString(name))
  result = call_574196.call(path_574197, query_574198, nil, nil, nil)

var metadataGet* = Call_MetadataGet_574176(name: "metadataGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/providers/Microsoft.ResourceHealth/metadata/{name}",
                                        validator: validate_MetadataGet_574177,
                                        base: "", url: url_MetadataGet_574178,
                                        schemes: {Scheme.Https})
type
  Call_OperationsList_574199 = ref object of OpenApiRestCall_573658
proc url_OperationsList_574201(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574200(path: JsonNode; query: JsonNode;
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
  var valid_574202 = query.getOrDefault("api-version")
  valid_574202 = validateParameter(valid_574202, JString, required = true,
                                 default = nil)
  if valid_574202 != nil:
    section.add "api-version", valid_574202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574203: Call_OperationsList_574199; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations for the resourcehealth resource provider
  ## 
  let valid = call_574203.validator(path, query, header, formData, body)
  let scheme = call_574203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574203.url(scheme.get, call_574203.host, call_574203.base,
                         call_574203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574203, url, valid)

proc call*(call_574204: Call_OperationsList_574199; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations for the resourcehealth resource provider
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574205 = newJObject()
  add(query_574205, "api-version", newJString(apiVersion))
  result = call_574204.call(nil, query_574205, nil, nil, nil)

var operationsList* = Call_OperationsList_574199(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ResourceHealth/operations",
    validator: validate_OperationsList_574200, base: "", url: url_OperationsList_574201,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListBySubscriptionId_574206 = ref object of OpenApiRestCall_573658
proc url_AvailabilityStatusesListBySubscriptionId_574208(protocol: Scheme;
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

proc validate_AvailabilityStatusesListBySubscriptionId_574207(path: JsonNode;
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
  var valid_574210 = path.getOrDefault("subscriptionId")
  valid_574210 = validateParameter(valid_574210, JString, required = true,
                                 default = nil)
  if valid_574210 != nil:
    section.add "subscriptionId", valid_574210
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
  var valid_574211 = query.getOrDefault("api-version")
  valid_574211 = validateParameter(valid_574211, JString, required = true,
                                 default = nil)
  if valid_574211 != nil:
    section.add "api-version", valid_574211
  var valid_574212 = query.getOrDefault("$expand")
  valid_574212 = validateParameter(valid_574212, JString, required = false,
                                 default = nil)
  if valid_574212 != nil:
    section.add "$expand", valid_574212
  var valid_574213 = query.getOrDefault("$filter")
  valid_574213 = validateParameter(valid_574213, JString, required = false,
                                 default = nil)
  if valid_574213 != nil:
    section.add "$filter", valid_574213
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574214: Call_AvailabilityStatusesListBySubscriptionId_574206;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the subscription.
  ## 
  let valid = call_574214.validator(path, query, header, formData, body)
  let scheme = call_574214.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574214.url(scheme.get, call_574214.host, call_574214.base,
                         call_574214.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574214, url, valid)

proc call*(call_574215: Call_AvailabilityStatusesListBySubscriptionId_574206;
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
  var path_574216 = newJObject()
  var query_574217 = newJObject()
  add(query_574217, "api-version", newJString(apiVersion))
  add(query_574217, "$expand", newJString(Expand))
  add(path_574216, "subscriptionId", newJString(subscriptionId))
  add(query_574217, "$filter", newJString(Filter))
  result = call_574215.call(path_574216, query_574217, nil, nil, nil)

var availabilityStatusesListBySubscriptionId* = Call_AvailabilityStatusesListBySubscriptionId_574206(
    name: "availabilityStatusesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListBySubscriptionId_574207, base: "",
    url: url_AvailabilityStatusesListBySubscriptionId_574208,
    schemes: {Scheme.Https})
type
  Call_EventsListBySubscriptionId_574218 = ref object of OpenApiRestCall_573658
proc url_EventsListBySubscriptionId_574220(protocol: Scheme; host: string;
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

proc validate_EventsListBySubscriptionId_574219(path: JsonNode; query: JsonNode;
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
  var valid_574221 = path.getOrDefault("subscriptionId")
  valid_574221 = validateParameter(valid_574221, JString, required = true,
                                 default = nil)
  if valid_574221 != nil:
    section.add "subscriptionId", valid_574221
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574222 = query.getOrDefault("api-version")
  valid_574222 = validateParameter(valid_574222, JString, required = true,
                                 default = nil)
  if valid_574222 != nil:
    section.add "api-version", valid_574222
  var valid_574223 = query.getOrDefault("$filter")
  valid_574223 = validateParameter(valid_574223, JString, required = false,
                                 default = nil)
  if valid_574223 != nil:
    section.add "$filter", valid_574223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574224: Call_EventsListBySubscriptionId_574218; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists current service health events in the subscription.
  ## 
  let valid = call_574224.validator(path, query, header, formData, body)
  let scheme = call_574224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574224.url(scheme.get, call_574224.host, call_574224.base,
                         call_574224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574224, url, valid)

proc call*(call_574225: Call_EventsListBySubscriptionId_574218; apiVersion: string;
          subscriptionId: string; Filter: string = ""): Recallable =
  ## eventsListBySubscriptionId
  ## Lists current service health events in the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574226 = newJObject()
  var query_574227 = newJObject()
  add(query_574227, "api-version", newJString(apiVersion))
  add(path_574226, "subscriptionId", newJString(subscriptionId))
  add(query_574227, "$filter", newJString(Filter))
  result = call_574225.call(path_574226, query_574227, nil, nil, nil)

var eventsListBySubscriptionId* = Call_EventsListBySubscriptionId_574218(
    name: "eventsListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/events",
    validator: validate_EventsListBySubscriptionId_574219, base: "",
    url: url_EventsListBySubscriptionId_574220, schemes: {Scheme.Https})
type
  Call_ImpactedResourcesListBySubscriptionId_574228 = ref object of OpenApiRestCall_573658
proc url_ImpactedResourcesListBySubscriptionId_574230(protocol: Scheme;
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
        value: "/providers/Microsoft.ResourceHealth/impactedResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImpactedResourcesListBySubscriptionId_574229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the current availability status for impacted resources in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_574231 = path.getOrDefault("subscriptionId")
  valid_574231 = validateParameter(valid_574231, JString, required = true,
                                 default = nil)
  if valid_574231 != nil:
    section.add "subscriptionId", valid_574231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574232 = query.getOrDefault("api-version")
  valid_574232 = validateParameter(valid_574232, JString, required = true,
                                 default = nil)
  if valid_574232 != nil:
    section.add "api-version", valid_574232
  var valid_574233 = query.getOrDefault("$filter")
  valid_574233 = validateParameter(valid_574233, JString, required = false,
                                 default = nil)
  if valid_574233 != nil:
    section.add "$filter", valid_574233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574234: Call_ImpactedResourcesListBySubscriptionId_574228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for impacted resources in the subscription.
  ## 
  let valid = call_574234.validator(path, query, header, formData, body)
  let scheme = call_574234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574234.url(scheme.get, call_574234.host, call_574234.base,
                         call_574234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574234, url, valid)

proc call*(call_574235: Call_ImpactedResourcesListBySubscriptionId_574228;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## impactedResourcesListBySubscriptionId
  ## Lists the current availability status for impacted resources in the subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574236 = newJObject()
  var query_574237 = newJObject()
  add(query_574237, "api-version", newJString(apiVersion))
  add(path_574236, "subscriptionId", newJString(subscriptionId))
  add(query_574237, "$filter", newJString(Filter))
  result = call_574235.call(path_574236, query_574237, nil, nil, nil)

var impactedResourcesListBySubscriptionId* = Call_ImpactedResourcesListBySubscriptionId_574228(
    name: "impactedResourcesListBySubscriptionId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ResourceHealth/impactedResources",
    validator: validate_ImpactedResourcesListBySubscriptionId_574229, base: "",
    url: url_ImpactedResourcesListBySubscriptionId_574230, schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesListByResourceGroup_574238 = ref object of OpenApiRestCall_573658
proc url_AvailabilityStatusesListByResourceGroup_574240(protocol: Scheme;
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

proc validate_AvailabilityStatusesListByResourceGroup_574239(path: JsonNode;
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
  var valid_574241 = path.getOrDefault("resourceGroupName")
  valid_574241 = validateParameter(valid_574241, JString, required = true,
                                 default = nil)
  if valid_574241 != nil:
    section.add "resourceGroupName", valid_574241
  var valid_574242 = path.getOrDefault("subscriptionId")
  valid_574242 = validateParameter(valid_574242, JString, required = true,
                                 default = nil)
  if valid_574242 != nil:
    section.add "subscriptionId", valid_574242
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
  var valid_574243 = query.getOrDefault("api-version")
  valid_574243 = validateParameter(valid_574243, JString, required = true,
                                 default = nil)
  if valid_574243 != nil:
    section.add "api-version", valid_574243
  var valid_574244 = query.getOrDefault("$expand")
  valid_574244 = validateParameter(valid_574244, JString, required = false,
                                 default = nil)
  if valid_574244 != nil:
    section.add "$expand", valid_574244
  var valid_574245 = query.getOrDefault("$filter")
  valid_574245 = validateParameter(valid_574245, JString, required = false,
                                 default = nil)
  if valid_574245 != nil:
    section.add "$filter", valid_574245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574246: Call_AvailabilityStatusesListByResourceGroup_574238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the current availability status for all the resources in the resource group.
  ## 
  let valid = call_574246.validator(path, query, header, formData, body)
  let scheme = call_574246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574246.url(scheme.get, call_574246.host, call_574246.base,
                         call_574246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574246, url, valid)

proc call*(call_574247: Call_AvailabilityStatusesListByResourceGroup_574238;
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
  var path_574248 = newJObject()
  var query_574249 = newJObject()
  add(path_574248, "resourceGroupName", newJString(resourceGroupName))
  add(query_574249, "api-version", newJString(apiVersion))
  add(query_574249, "$expand", newJString(Expand))
  add(path_574248, "subscriptionId", newJString(subscriptionId))
  add(query_574249, "$filter", newJString(Filter))
  result = call_574247.call(path_574248, query_574249, nil, nil, nil)

var availabilityStatusesListByResourceGroup* = Call_AvailabilityStatusesListByResourceGroup_574238(
    name: "availabilityStatusesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesListByResourceGroup_574239, base: "",
    url: url_AvailabilityStatusesListByResourceGroup_574240,
    schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesList_574250 = ref object of OpenApiRestCall_573658
proc url_AvailabilityStatusesList_574252(protocol: Scheme; host: string;
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

proc validate_AvailabilityStatusesList_574251(path: JsonNode; query: JsonNode;
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
  var valid_574253 = path.getOrDefault("resourceUri")
  valid_574253 = validateParameter(valid_574253, JString, required = true,
                                 default = nil)
  if valid_574253 != nil:
    section.add "resourceUri", valid_574253
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
  var valid_574254 = query.getOrDefault("api-version")
  valid_574254 = validateParameter(valid_574254, JString, required = true,
                                 default = nil)
  if valid_574254 != nil:
    section.add "api-version", valid_574254
  var valid_574255 = query.getOrDefault("$expand")
  valid_574255 = validateParameter(valid_574255, JString, required = false,
                                 default = nil)
  if valid_574255 != nil:
    section.add "$expand", valid_574255
  var valid_574256 = query.getOrDefault("$filter")
  valid_574256 = validateParameter(valid_574256, JString, required = false,
                                 default = nil)
  if valid_574256 != nil:
    section.add "$filter", valid_574256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574257: Call_AvailabilityStatusesList_574250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all historical availability transitions and impacting events for a single resource.
  ## 
  let valid = call_574257.validator(path, query, header, formData, body)
  let scheme = call_574257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574257.url(scheme.get, call_574257.host, call_574257.base,
                         call_574257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574257, url, valid)

proc call*(call_574258: Call_AvailabilityStatusesList_574250; apiVersion: string;
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
  var path_574259 = newJObject()
  var query_574260 = newJObject()
  add(query_574260, "api-version", newJString(apiVersion))
  add(query_574260, "$expand", newJString(Expand))
  add(path_574259, "resourceUri", newJString(resourceUri))
  add(query_574260, "$filter", newJString(Filter))
  result = call_574258.call(path_574259, query_574260, nil, nil, nil)

var availabilityStatusesList* = Call_AvailabilityStatusesList_574250(
    name: "availabilityStatusesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses",
    validator: validate_AvailabilityStatusesList_574251, base: "",
    url: url_AvailabilityStatusesList_574252, schemes: {Scheme.Https})
type
  Call_AvailabilityStatusesGetByResource_574261 = ref object of OpenApiRestCall_573658
proc url_AvailabilityStatusesGetByResource_574263(protocol: Scheme; host: string;
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

proc validate_AvailabilityStatusesGetByResource_574262(path: JsonNode;
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
  var valid_574264 = path.getOrDefault("resourceUri")
  valid_574264 = validateParameter(valid_574264, JString, required = true,
                                 default = nil)
  if valid_574264 != nil:
    section.add "resourceUri", valid_574264
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
  var valid_574265 = query.getOrDefault("api-version")
  valid_574265 = validateParameter(valid_574265, JString, required = true,
                                 default = nil)
  if valid_574265 != nil:
    section.add "api-version", valid_574265
  var valid_574266 = query.getOrDefault("$expand")
  valid_574266 = validateParameter(valid_574266, JString, required = false,
                                 default = nil)
  if valid_574266 != nil:
    section.add "$expand", valid_574266
  var valid_574267 = query.getOrDefault("$filter")
  valid_574267 = validateParameter(valid_574267, JString, required = false,
                                 default = nil)
  if valid_574267 != nil:
    section.add "$filter", valid_574267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574268: Call_AvailabilityStatusesGetByResource_574261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets current availability status for a single resource
  ## 
  let valid = call_574268.validator(path, query, header, formData, body)
  let scheme = call_574268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574268.url(scheme.get, call_574268.host, call_574268.base,
                         call_574268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574268, url, valid)

proc call*(call_574269: Call_AvailabilityStatusesGetByResource_574261;
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
  var path_574270 = newJObject()
  var query_574271 = newJObject()
  add(query_574271, "api-version", newJString(apiVersion))
  add(query_574271, "$expand", newJString(Expand))
  add(path_574270, "resourceUri", newJString(resourceUri))
  add(query_574271, "$filter", newJString(Filter))
  result = call_574269.call(path_574270, query_574271, nil, nil, nil)

var availabilityStatusesGetByResource* = Call_AvailabilityStatusesGetByResource_574261(
    name: "availabilityStatusesGetByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/Microsoft.ResourceHealth/availabilityStatuses/current",
    validator: validate_AvailabilityStatusesGetByResource_574262, base: "",
    url: url_AvailabilityStatusesGetByResource_574263, schemes: {Scheme.Https})
type
  Call_EventsListBySingleResource_574272 = ref object of OpenApiRestCall_573658
proc url_EventsListBySingleResource_574274(protocol: Scheme; host: string;
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

proc validate_EventsListBySingleResource_574273(path: JsonNode; query: JsonNode;
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
  var valid_574275 = path.getOrDefault("resourceUri")
  valid_574275 = validateParameter(valid_574275, JString, required = true,
                                 default = nil)
  if valid_574275 != nil:
    section.add "resourceUri", valid_574275
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574276 = query.getOrDefault("api-version")
  valid_574276 = validateParameter(valid_574276, JString, required = true,
                                 default = nil)
  if valid_574276 != nil:
    section.add "api-version", valid_574276
  var valid_574277 = query.getOrDefault("$filter")
  valid_574277 = validateParameter(valid_574277, JString, required = false,
                                 default = nil)
  if valid_574277 != nil:
    section.add "$filter", valid_574277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574278: Call_EventsListBySingleResource_574272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists current service health events for given resource.
  ## 
  let valid = call_574278.validator(path, query, header, formData, body)
  let scheme = call_574278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574278.url(scheme.get, call_574278.host, call_574278.base,
                         call_574278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574278, url, valid)

proc call*(call_574279: Call_EventsListBySingleResource_574272; apiVersion: string;
          resourceUri: string; Filter: string = ""): Recallable =
  ## eventsListBySingleResource
  ## Lists current service health events for given resource.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type. Currently the API support not nested and one nesting level resource types : 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resource-group-name}/providers/{resource-provider-name}/{resource-type}/{resource-name} and 
  ## /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resource-provider-name}/{parentResourceType}/{parentResourceName}/{resourceType}/{resourceName}
  ##   Filter: string
  ##         : The filter to apply on the operation. For more information please see 
  ## https://docs.microsoft.com/en-us/rest/api/apimanagement/apis?redirectedfrom=MSDN
  var path_574280 = newJObject()
  var query_574281 = newJObject()
  add(query_574281, "api-version", newJString(apiVersion))
  add(path_574280, "resourceUri", newJString(resourceUri))
  add(query_574281, "$filter", newJString(Filter))
  result = call_574279.call(path_574280, query_574281, nil, nil, nil)

var eventsListBySingleResource* = Call_EventsListBySingleResource_574272(
    name: "eventsListBySingleResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{resourceUri}/providers/Microsoft.ResourceHealth/events",
    validator: validate_EventsListBySingleResource_574273, base: "",
    url: url_EventsListBySingleResource_574274, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

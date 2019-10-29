
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Application Insights Data Plane
## version: 2018-04-20
## termsOfService: https://dev.applicationinsights.io/tos
## license:
##     name: Microsoft
##     url: https://dev.applicationinsights.io/license
## 
## This API exposes AI metric & event information and associated metadata
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

  OpenApiRestCall_563565 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563565](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563565): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "applicationinsights-swagger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EventsGetOdataMetadata_563787 = ref object of OpenApiRestCall_563565
proc url_EventsGetOdataMetadata_563789(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/events/$metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsGetOdataMetadata_563788(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets OData EDMX metadata describing the event data model
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_563964 = path.getOrDefault("applicationName")
  valid_563964 = validateParameter(valid_563964, JString, required = true,
                                 default = nil)
  if valid_563964 != nil:
    section.add "applicationName", valid_563964
  var valid_563965 = path.getOrDefault("subscriptionId")
  valid_563965 = validateParameter(valid_563965, JString, required = true,
                                 default = nil)
  if valid_563965 != nil:
    section.add "subscriptionId", valid_563965
  var valid_563966 = path.getOrDefault("resourceGroupName")
  valid_563966 = validateParameter(valid_563966, JString, required = true,
                                 default = nil)
  if valid_563966 != nil:
    section.add "resourceGroupName", valid_563966
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_563967 = query.getOrDefault("apiVersion")
  valid_563967 = validateParameter(valid_563967, JString, required = true,
                                 default = nil)
  if valid_563967 != nil:
    section.add "apiVersion", valid_563967
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563990: Call_EventsGetOdataMetadata_563787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData EDMX metadata describing the event data model
  ## 
  let valid = call_563990.validator(path, query, header, formData, body)
  let scheme = call_563990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563990.url(scheme.get, call_563990.host, call_563990.base,
                         call_563990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563990, url, valid)

proc call*(call_564061: Call_EventsGetOdataMetadata_563787;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string): Recallable =
  ## eventsGetOdataMetadata
  ## Gets OData EDMX metadata describing the event data model
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_564062 = newJObject()
  var query_564064 = newJObject()
  add(path_564062, "applicationName", newJString(applicationName))
  add(path_564062, "subscriptionId", newJString(subscriptionId))
  add(path_564062, "resourceGroupName", newJString(resourceGroupName))
  add(query_564064, "apiVersion", newJString(apiVersion))
  result = call_564061.call(path_564062, query_564064, nil, nil, nil)

var eventsGetOdataMetadata* = Call_EventsGetOdataMetadata_563787(
    name: "eventsGetOdataMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/$metadata",
    validator: validate_EventsGetOdataMetadata_563788, base: "",
    url: url_EventsGetOdataMetadata_563789, schemes: {Scheme.Https})
type
  Call_EventsGetByType_564103 = ref object of OpenApiRestCall_563565
proc url_EventsGetByType_564105(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "eventType" in path, "`eventType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventType")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsGetByType_564104(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Executes an OData query for events
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   eventType: JString (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564107 = path.getOrDefault("applicationName")
  valid_564107 = validateParameter(valid_564107, JString, required = true,
                                 default = nil)
  if valid_564107 != nil:
    section.add "applicationName", valid_564107
  var valid_564108 = path.getOrDefault("subscriptionId")
  valid_564108 = validateParameter(valid_564108, JString, required = true,
                                 default = nil)
  if valid_564108 != nil:
    section.add "subscriptionId", valid_564108
  var valid_564109 = path.getOrDefault("resourceGroupName")
  valid_564109 = validateParameter(valid_564109, JString, required = true,
                                 default = nil)
  if valid_564109 != nil:
    section.add "resourceGroupName", valid_564109
  var valid_564123 = path.getOrDefault("eventType")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = newJString("$all"))
  if valid_564123 != nil:
    section.add "eventType", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   $top: JInt
  ##       : The number of events to return
  ##   timespan: JString
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   $select: JString
  ##          : Limits the properties to just those requested on each returned event
  ##   $format: JString
  ##          : Format for the returned events
  ##   $count: JBool
  ##         : Request a count of matching items included with the returned events
  ##   $orderby: JString
  ##           : A comma-separated list of properties with \"asc\" (the default) or \"desc\" to control the order of returned events
  ##   $apply: JString
  ##         : An expression used for aggregation over returned events
  ##   $skip: JInt
  ##        : The number of items to skip over before returning events
  ##   $filter: JString
  ##          : An expression used to filter the returned events
  ##   $search: JString
  ##          : A free-text search expression to match for whether a particular event should be returned
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_564124 = query.getOrDefault("$top")
  valid_564124 = validateParameter(valid_564124, JInt, required = false, default = nil)
  if valid_564124 != nil:
    section.add "$top", valid_564124
  var valid_564125 = query.getOrDefault("timespan")
  valid_564125 = validateParameter(valid_564125, JString, required = false,
                                 default = nil)
  if valid_564125 != nil:
    section.add "timespan", valid_564125
  var valid_564126 = query.getOrDefault("$select")
  valid_564126 = validateParameter(valid_564126, JString, required = false,
                                 default = nil)
  if valid_564126 != nil:
    section.add "$select", valid_564126
  var valid_564127 = query.getOrDefault("$format")
  valid_564127 = validateParameter(valid_564127, JString, required = false,
                                 default = nil)
  if valid_564127 != nil:
    section.add "$format", valid_564127
  var valid_564128 = query.getOrDefault("$count")
  valid_564128 = validateParameter(valid_564128, JBool, required = false, default = nil)
  if valid_564128 != nil:
    section.add "$count", valid_564128
  var valid_564129 = query.getOrDefault("$orderby")
  valid_564129 = validateParameter(valid_564129, JString, required = false,
                                 default = nil)
  if valid_564129 != nil:
    section.add "$orderby", valid_564129
  var valid_564130 = query.getOrDefault("$apply")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = nil)
  if valid_564130 != nil:
    section.add "$apply", valid_564130
  var valid_564131 = query.getOrDefault("$skip")
  valid_564131 = validateParameter(valid_564131, JInt, required = false, default = nil)
  if valid_564131 != nil:
    section.add "$skip", valid_564131
  var valid_564132 = query.getOrDefault("$filter")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "$filter", valid_564132
  var valid_564133 = query.getOrDefault("$search")
  valid_564133 = validateParameter(valid_564133, JString, required = false,
                                 default = nil)
  if valid_564133 != nil:
    section.add "$search", valid_564133
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_564134 = query.getOrDefault("apiVersion")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "apiVersion", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564135: Call_EventsGetByType_564103; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an OData query for events
  ## 
  let valid = call_564135.validator(path, query, header, formData, body)
  let scheme = call_564135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564135.url(scheme.get, call_564135.host, call_564135.base,
                         call_564135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564135, url, valid)

proc call*(call_564136: Call_EventsGetByType_564103; applicationName: string;
          subscriptionId: string; resourceGroupName: string; apiVersion: string;
          Top: int = 0; timespan: string = ""; Select: string = ""; Format: string = "";
          Count: bool = false; Orderby: string = ""; Apply: string = ""; Skip: int = 0;
          Filter: string = ""; Search: string = ""; eventType: string = "$all"): Recallable =
  ## eventsGetByType
  ## Executes an OData query for events
  ##   Top: int
  ##      : The number of events to return
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   timespan: string
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   Select: string
  ##         : Limits the properties to just those requested on each returned event
  ##   Format: string
  ##         : Format for the returned events
  ##   Count: bool
  ##        : Request a count of matching items included with the returned events
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : A comma-separated list of properties with \"asc\" (the default) or \"desc\" to control the order of returned events
  ##   Apply: string
  ##        : An expression used for aggregation over returned events
  ##   Skip: int
  ##       : The number of items to skip over before returning events
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   Filter: string
  ##         : An expression used to filter the returned events
  ##   Search: string
  ##         : A free-text search expression to match for whether a particular event should be returned
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   eventType: string (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  var path_564137 = newJObject()
  var query_564138 = newJObject()
  add(query_564138, "$top", newJInt(Top))
  add(path_564137, "applicationName", newJString(applicationName))
  add(query_564138, "timespan", newJString(timespan))
  add(query_564138, "$select", newJString(Select))
  add(query_564138, "$format", newJString(Format))
  add(query_564138, "$count", newJBool(Count))
  add(path_564137, "subscriptionId", newJString(subscriptionId))
  add(query_564138, "$orderby", newJString(Orderby))
  add(query_564138, "$apply", newJString(Apply))
  add(query_564138, "$skip", newJInt(Skip))
  add(path_564137, "resourceGroupName", newJString(resourceGroupName))
  add(query_564138, "$filter", newJString(Filter))
  add(query_564138, "$search", newJString(Search))
  add(query_564138, "apiVersion", newJString(apiVersion))
  add(path_564137, "eventType", newJString(eventType))
  result = call_564136.call(path_564137, query_564138, nil, nil, nil)

var eventsGetByType* = Call_EventsGetByType_564103(name: "eventsGetByType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/{eventType}",
    validator: validate_EventsGetByType_564104, base: "", url: url_EventsGetByType_564105,
    schemes: {Scheme.Https})
type
  Call_EventsGet_564139 = ref object of OpenApiRestCall_563565
proc url_EventsGet_564141(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "eventType" in path, "`eventType` is a required path parameter"
  assert "eventId" in path, "`eventId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/events/"),
               (kind: VariableSegment, value: "eventType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "eventId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EventsGet_564140(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the data for a single event
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   eventId: JString (required)
  ##          : ID of event.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   eventType: JString (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `eventId` field"
  var valid_564142 = path.getOrDefault("eventId")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "eventId", valid_564142
  var valid_564143 = path.getOrDefault("applicationName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "applicationName", valid_564143
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
  var valid_564145 = path.getOrDefault("resourceGroupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "resourceGroupName", valid_564145
  var valid_564146 = path.getOrDefault("eventType")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = newJString("$all"))
  if valid_564146 != nil:
    section.add "eventType", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   timespan: JString
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_564147 = query.getOrDefault("timespan")
  valid_564147 = validateParameter(valid_564147, JString, required = false,
                                 default = nil)
  if valid_564147 != nil:
    section.add "timespan", valid_564147
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_564148 = query.getOrDefault("apiVersion")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "apiVersion", valid_564148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_EventsGet_564139; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data for a single event
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_EventsGet_564139; eventId: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string; timespan: string = "";
          eventType: string = "$all"): Recallable =
  ## eventsGet
  ## Gets the data for a single event
  ##   eventId: string (required)
  ##          : ID of event.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   timespan: string
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   eventType: string (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  add(path_564151, "eventId", newJString(eventId))
  add(path_564151, "applicationName", newJString(applicationName))
  add(query_564152, "timespan", newJString(timespan))
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(query_564152, "apiVersion", newJString(apiVersion))
  add(path_564151, "eventType", newJString(eventType))
  result = call_564150.call(path_564151, query_564152, nil, nil, nil)

var eventsGet* = Call_EventsGet_564139(name: "eventsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/{eventType}/{eventId}",
                                    validator: validate_EventsGet_564140,
                                    base: "", url: url_EventsGet_564141,
                                    schemes: {Scheme.Https})
type
  Call_MetricsGetMetadata_564153 = ref object of OpenApiRestCall_563565
proc url_MetricsGetMetadata_564155(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/metrics/metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetricsGetMetadata_564154(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets metadata describing the available metrics
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564156 = path.getOrDefault("applicationName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "applicationName", valid_564156
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("resourceGroupName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceGroupName", valid_564158
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_564159 = query.getOrDefault("apiVersion")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "apiVersion", valid_564159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564160: Call_MetricsGetMetadata_564153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets metadata describing the available metrics
  ## 
  let valid = call_564160.validator(path, query, header, formData, body)
  let scheme = call_564160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564160.url(scheme.get, call_564160.host, call_564160.base,
                         call_564160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564160, url, valid)

proc call*(call_564161: Call_MetricsGetMetadata_564153; applicationName: string;
          subscriptionId: string; resourceGroupName: string; apiVersion: string): Recallable =
  ## metricsGetMetadata
  ## Gets metadata describing the available metrics
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_564162 = newJObject()
  var query_564163 = newJObject()
  add(path_564162, "applicationName", newJString(applicationName))
  add(path_564162, "subscriptionId", newJString(subscriptionId))
  add(path_564162, "resourceGroupName", newJString(resourceGroupName))
  add(query_564163, "apiVersion", newJString(apiVersion))
  result = call_564161.call(path_564162, query_564163, nil, nil, nil)

var metricsGetMetadata* = Call_MetricsGetMetadata_564153(
    name: "metricsGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/metrics/metadata",
    validator: validate_MetricsGetMetadata_564154, base: "",
    url: url_MetricsGetMetadata_564155, schemes: {Scheme.Https})
type
  Call_MetricsGet_564164 = ref object of OpenApiRestCall_563565
proc url_MetricsGet_564166(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "metricId" in path, "`metricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/metrics/"),
               (kind: VariableSegment, value: "metricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MetricsGet_564165(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets metric values for a single metric
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   metricId: JString (required)
  ##           : ID of the metric. This is either a standard AI metric, or an application-specific custom metric.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564167 = path.getOrDefault("applicationName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "applicationName", valid_564167
  var valid_564168 = path.getOrDefault("metricId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = newJString("requests/count"))
  if valid_564168 != nil:
    section.add "metricId", valid_564168
  var valid_564169 = path.getOrDefault("subscriptionId")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "subscriptionId", valid_564169
  var valid_564170 = path.getOrDefault("resourceGroupName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "resourceGroupName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   segment: JArray
  ##          : The name of the dimension to segment the metric values by. This dimension must be applicable to the metric you are retrieving. To segment by more than one dimension at a time, separate them with a comma (,). In this case, the metric data will be segmented in the order the dimensions are listed in the parameter.
  ##   aggregation: JArray
  ##              : The aggregation to use when computing the metric values. To retrieve more than one aggregation at a time, separate them with a comma. If no aggregation is specified, then the default aggregation for the metric is used.
  ##   timespan: JString
  ##           : The timespan over which to retrieve metric values. This is an ISO8601 time period value. If timespan is omitted, a default time range of `PT12H` ("last 12 hours") is used. The actual timespan that is queried may be adjusted by the server based. In all cases, the actual time span used for the query is included in the response.
  ##   interval: JString
  ##           : The time interval to use when retrieving metric values. This is an ISO8601 duration. If interval is omitted, the metric value is aggregated across the entire timespan. If interval is supplied, the server may adjust the interval to a more appropriate size based on the timespan used for the query. In all cases, the actual interval used for the query is included in the response.
  ##   filter: JString
  ##         : An expression used to filter the results.  This value should be a valid OData filter expression where the keys of each clause should be applicable dimensions for the metric you are retrieving.
  ##   orderby: JString
  ##          : The aggregation function and direction to sort the segments by.  This value is only valid when segment is specified.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  ##   top: JInt
  ##      : The number of segments to return.  This value is only valid when segment is specified.
  section = newJObject()
  var valid_564171 = query.getOrDefault("segment")
  valid_564171 = validateParameter(valid_564171, JArray, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "segment", valid_564171
  var valid_564172 = query.getOrDefault("aggregation")
  valid_564172 = validateParameter(valid_564172, JArray, required = false,
                                 default = nil)
  if valid_564172 != nil:
    section.add "aggregation", valid_564172
  var valid_564173 = query.getOrDefault("timespan")
  valid_564173 = validateParameter(valid_564173, JString, required = false,
                                 default = nil)
  if valid_564173 != nil:
    section.add "timespan", valid_564173
  var valid_564174 = query.getOrDefault("interval")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = nil)
  if valid_564174 != nil:
    section.add "interval", valid_564174
  var valid_564175 = query.getOrDefault("filter")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "filter", valid_564175
  var valid_564176 = query.getOrDefault("orderby")
  valid_564176 = validateParameter(valid_564176, JString, required = false,
                                 default = nil)
  if valid_564176 != nil:
    section.add "orderby", valid_564176
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_564177 = query.getOrDefault("apiVersion")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "apiVersion", valid_564177
  var valid_564178 = query.getOrDefault("top")
  valid_564178 = validateParameter(valid_564178, JInt, required = false, default = nil)
  if valid_564178 != nil:
    section.add "top", valid_564178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564179: Call_MetricsGet_564164; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets metric values for a single metric
  ## 
  let valid = call_564179.validator(path, query, header, formData, body)
  let scheme = call_564179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564179.url(scheme.get, call_564179.host, call_564179.base,
                         call_564179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564179, url, valid)

proc call*(call_564180: Call_MetricsGet_564164; applicationName: string;
          subscriptionId: string; resourceGroupName: string; apiVersion: string;
          segment: JsonNode = nil; aggregation: JsonNode = nil; timespan: string = "";
          metricId: string = "requests/count"; interval: string = "";
          filter: string = ""; orderby: string = ""; top: int = 0): Recallable =
  ## metricsGet
  ## Gets metric values for a single metric
  ##   segment: JArray
  ##          : The name of the dimension to segment the metric values by. This dimension must be applicable to the metric you are retrieving. To segment by more than one dimension at a time, separate them with a comma (,). In this case, the metric data will be segmented in the order the dimensions are listed in the parameter.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   aggregation: JArray
  ##              : The aggregation to use when computing the metric values. To retrieve more than one aggregation at a time, separate them with a comma. If no aggregation is specified, then the default aggregation for the metric is used.
  ##   timespan: string
  ##           : The timespan over which to retrieve metric values. This is an ISO8601 time period value. If timespan is omitted, a default time range of `PT12H` ("last 12 hours") is used. The actual timespan that is queried may be adjusted by the server based. In all cases, the actual time span used for the query is included in the response.
  ##   metricId: string (required)
  ##           : ID of the metric. This is either a standard AI metric, or an application-specific custom metric.
  ##   interval: string
  ##           : The time interval to use when retrieving metric values. This is an ISO8601 duration. If interval is omitted, the metric value is aggregated across the entire timespan. If interval is supplied, the server may adjust the interval to a more appropriate size based on the timespan used for the query. In all cases, the actual interval used for the query is included in the response.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   filter: string
  ##         : An expression used to filter the results.  This value should be a valid OData filter expression where the keys of each clause should be applicable dimensions for the metric you are retrieving.
  ##   orderby: string
  ##          : The aggregation function and direction to sort the segments by.  This value is only valid when segment is specified.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   top: int
  ##      : The number of segments to return.  This value is only valid when segment is specified.
  var path_564181 = newJObject()
  var query_564182 = newJObject()
  if segment != nil:
    query_564182.add "segment", segment
  add(path_564181, "applicationName", newJString(applicationName))
  if aggregation != nil:
    query_564182.add "aggregation", aggregation
  add(query_564182, "timespan", newJString(timespan))
  add(path_564181, "metricId", newJString(metricId))
  add(query_564182, "interval", newJString(interval))
  add(path_564181, "subscriptionId", newJString(subscriptionId))
  add(query_564182, "filter", newJString(filter))
  add(query_564182, "orderby", newJString(orderby))
  add(path_564181, "resourceGroupName", newJString(resourceGroupName))
  add(query_564182, "apiVersion", newJString(apiVersion))
  add(query_564182, "top", newJInt(top))
  result = call_564180.call(path_564181, query_564182, nil, nil, nil)

var metricsGet* = Call_MetricsGet_564164(name: "metricsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/metrics/{metricId}",
                                      validator: validate_MetricsGet_564165,
                                      base: "", url: url_MetricsGet_564166,
                                      schemes: {Scheme.Https})
type
  Call_QueryExecute_564196 = ref object of OpenApiRestCall_563565
proc url_QueryExecute_564198(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryExecute_564197(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564199 = path.getOrDefault("applicationName")
  valid_564199 = validateParameter(valid_564199, JString, required = true,
                                 default = nil)
  if valid_564199 != nil:
    section.add "applicationName", valid_564199
  var valid_564200 = path.getOrDefault("subscriptionId")
  valid_564200 = validateParameter(valid_564200, JString, required = true,
                                 default = nil)
  if valid_564200 != nil:
    section.add "subscriptionId", valid_564200
  var valid_564201 = path.getOrDefault("resourceGroupName")
  valid_564201 = validateParameter(valid_564201, JString, required = true,
                                 default = nil)
  if valid_564201 != nil:
    section.add "resourceGroupName", valid_564201
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_564202 = query.getOrDefault("apiVersion")
  valid_564202 = validateParameter(valid_564202, JString, required = true,
                                 default = nil)
  if valid_564202 != nil:
    section.add "apiVersion", valid_564202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564204: Call_QueryExecute_564196; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ## 
  let valid = call_564204.validator(path, query, header, formData, body)
  let scheme = call_564204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564204.url(scheme.get, call_564204.host, call_564204.base,
                         call_564204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564204, url, valid)

proc call*(call_564205: Call_QueryExecute_564196; applicationName: string;
          subscriptionId: string; resourceGroupName: string; body: JsonNode;
          apiVersion: string): Recallable =
  ## queryExecute
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   body: JObject (required)
  ##       : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_564206 = newJObject()
  var query_564207 = newJObject()
  var body_564208 = newJObject()
  add(path_564206, "applicationName", newJString(applicationName))
  add(path_564206, "subscriptionId", newJString(subscriptionId))
  add(path_564206, "resourceGroupName", newJString(resourceGroupName))
  if body != nil:
    body_564208 = body
  add(query_564207, "apiVersion", newJString(apiVersion))
  result = call_564205.call(path_564206, query_564207, nil, nil, body_564208)

var queryExecute* = Call_QueryExecute_564196(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/query",
    validator: validate_QueryExecute_564197, base: "", url: url_QueryExecute_564198,
    schemes: {Scheme.Https})
type
  Call_QueryGet_564183 = ref object of OpenApiRestCall_563565
proc url_QueryGet_564185(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Insights/components/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/query")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_QueryGet_564184(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an Analytics query for data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564186 = path.getOrDefault("applicationName")
  valid_564186 = validateParameter(valid_564186, JString, required = true,
                                 default = nil)
  if valid_564186 != nil:
    section.add "applicationName", valid_564186
  var valid_564187 = path.getOrDefault("subscriptionId")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = nil)
  if valid_564187 != nil:
    section.add "subscriptionId", valid_564187
  var valid_564188 = path.getOrDefault("resourceGroupName")
  valid_564188 = validateParameter(valid_564188, JString, required = true,
                                 default = nil)
  if valid_564188 != nil:
    section.add "resourceGroupName", valid_564188
  result.add "path", section
  ## parameters in `query` object:
  ##   timespan: JString
  ##           : Optional. The timespan over which to query data. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the query expression.
  ##   query: JString (required)
  ##        : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_564189 = query.getOrDefault("timespan")
  valid_564189 = validateParameter(valid_564189, JString, required = false,
                                 default = nil)
  if valid_564189 != nil:
    section.add "timespan", valid_564189
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_564190 = query.getOrDefault("query")
  valid_564190 = validateParameter(valid_564190, JString, required = true,
                                 default = nil)
  if valid_564190 != nil:
    section.add "query", valid_564190
  var valid_564191 = query.getOrDefault("apiVersion")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "apiVersion", valid_564191
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564192: Call_QueryGet_564183; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data
  ## 
  let valid = call_564192.validator(path, query, header, formData, body)
  let scheme = call_564192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564192.url(scheme.get, call_564192.host, call_564192.base,
                         call_564192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564192, url, valid)

proc call*(call_564193: Call_QueryGet_564183; applicationName: string;
          subscriptionId: string; resourceGroupName: string; query: string;
          apiVersion: string; timespan: string = ""): Recallable =
  ## queryGet
  ## Executes an Analytics query for data
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   timespan: string
  ##           : Optional. The timespan over which to query data. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the query expression.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   query: string (required)
  ##        : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_564194 = newJObject()
  var query_564195 = newJObject()
  add(path_564194, "applicationName", newJString(applicationName))
  add(query_564195, "timespan", newJString(timespan))
  add(path_564194, "subscriptionId", newJString(subscriptionId))
  add(path_564194, "resourceGroupName", newJString(resourceGroupName))
  add(query_564195, "query", newJString(query))
  add(query_564195, "apiVersion", newJString(apiVersion))
  result = call_564193.call(path_564194, query_564195, nil, nil, nil)

var queryGet* = Call_QueryGet_564183(name: "queryGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/query",
                                  validator: validate_QueryGet_564184, base: "",
                                  url: url_QueryGet_564185,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

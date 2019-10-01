
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_596467 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596467](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596467): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-swagger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EventsGetOdataMetadata_596689 = ref object of OpenApiRestCall_596467
proc url_EventsGetOdataMetadata_596691(protocol: Scheme; host: string; base: string;
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

proc validate_EventsGetOdataMetadata_596690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets OData EDMX metadata describing the event data model
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_596864 = path.getOrDefault("resourceGroupName")
  valid_596864 = validateParameter(valid_596864, JString, required = true,
                                 default = nil)
  if valid_596864 != nil:
    section.add "resourceGroupName", valid_596864
  var valid_596865 = path.getOrDefault("applicationName")
  valid_596865 = validateParameter(valid_596865, JString, required = true,
                                 default = nil)
  if valid_596865 != nil:
    section.add "applicationName", valid_596865
  var valid_596866 = path.getOrDefault("subscriptionId")
  valid_596866 = validateParameter(valid_596866, JString, required = true,
                                 default = nil)
  if valid_596866 != nil:
    section.add "subscriptionId", valid_596866
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_596867 = query.getOrDefault("apiVersion")
  valid_596867 = validateParameter(valid_596867, JString, required = true,
                                 default = nil)
  if valid_596867 != nil:
    section.add "apiVersion", valid_596867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596890: Call_EventsGetOdataMetadata_596689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData EDMX metadata describing the event data model
  ## 
  let valid = call_596890.validator(path, query, header, formData, body)
  let scheme = call_596890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596890.url(scheme.get, call_596890.host, call_596890.base,
                         call_596890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596890, url, valid)

proc call*(call_596961: Call_EventsGetOdataMetadata_596689;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string): Recallable =
  ## eventsGetOdataMetadata
  ## Gets OData EDMX metadata describing the event data model
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_596962 = newJObject()
  var query_596964 = newJObject()
  add(path_596962, "resourceGroupName", newJString(resourceGroupName))
  add(path_596962, "applicationName", newJString(applicationName))
  add(path_596962, "subscriptionId", newJString(subscriptionId))
  add(query_596964, "apiVersion", newJString(apiVersion))
  result = call_596961.call(path_596962, query_596964, nil, nil, nil)

var eventsGetOdataMetadata* = Call_EventsGetOdataMetadata_596689(
    name: "eventsGetOdataMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/$metadata",
    validator: validate_EventsGetOdataMetadata_596690, base: "",
    url: url_EventsGetOdataMetadata_596691, schemes: {Scheme.Https})
type
  Call_EventsGetByType_597003 = ref object of OpenApiRestCall_596467
proc url_EventsGetByType_597005(protocol: Scheme; host: string; base: string;
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

proc validate_EventsGetByType_597004(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Executes an OData query for events
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   eventType: JString (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597007 = path.getOrDefault("resourceGroupName")
  valid_597007 = validateParameter(valid_597007, JString, required = true,
                                 default = nil)
  if valid_597007 != nil:
    section.add "resourceGroupName", valid_597007
  var valid_597008 = path.getOrDefault("applicationName")
  valid_597008 = validateParameter(valid_597008, JString, required = true,
                                 default = nil)
  if valid_597008 != nil:
    section.add "applicationName", valid_597008
  var valid_597009 = path.getOrDefault("subscriptionId")
  valid_597009 = validateParameter(valid_597009, JString, required = true,
                                 default = nil)
  if valid_597009 != nil:
    section.add "subscriptionId", valid_597009
  var valid_597023 = path.getOrDefault("eventType")
  valid_597023 = validateParameter(valid_597023, JString, required = true,
                                 default = newJString("$all"))
  if valid_597023 != nil:
    section.add "eventType", valid_597023
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : A comma-separated list of properties with \"asc\" (the default) or \"desc\" to control the order of returned events
  ##   timespan: JString
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   $top: JInt
  ##       : The number of events to return
  ##   $select: JString
  ##          : Limits the properties to just those requested on each returned event
  ##   $skip: JInt
  ##        : The number of items to skip over before returning events
  ##   $count: JBool
  ##         : Request a count of matching items included with the returned events
  ##   $search: JString
  ##          : A free-text search expression to match for whether a particular event should be returned
  ##   $format: JString
  ##          : Format for the returned events
  ##   $apply: JString
  ##         : An expression used for aggregation over returned events
  ##   $filter: JString
  ##          : An expression used to filter the returned events
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_597024 = query.getOrDefault("$orderby")
  valid_597024 = validateParameter(valid_597024, JString, required = false,
                                 default = nil)
  if valid_597024 != nil:
    section.add "$orderby", valid_597024
  var valid_597025 = query.getOrDefault("timespan")
  valid_597025 = validateParameter(valid_597025, JString, required = false,
                                 default = nil)
  if valid_597025 != nil:
    section.add "timespan", valid_597025
  var valid_597026 = query.getOrDefault("$top")
  valid_597026 = validateParameter(valid_597026, JInt, required = false, default = nil)
  if valid_597026 != nil:
    section.add "$top", valid_597026
  var valid_597027 = query.getOrDefault("$select")
  valid_597027 = validateParameter(valid_597027, JString, required = false,
                                 default = nil)
  if valid_597027 != nil:
    section.add "$select", valid_597027
  var valid_597028 = query.getOrDefault("$skip")
  valid_597028 = validateParameter(valid_597028, JInt, required = false, default = nil)
  if valid_597028 != nil:
    section.add "$skip", valid_597028
  var valid_597029 = query.getOrDefault("$count")
  valid_597029 = validateParameter(valid_597029, JBool, required = false, default = nil)
  if valid_597029 != nil:
    section.add "$count", valid_597029
  var valid_597030 = query.getOrDefault("$search")
  valid_597030 = validateParameter(valid_597030, JString, required = false,
                                 default = nil)
  if valid_597030 != nil:
    section.add "$search", valid_597030
  var valid_597031 = query.getOrDefault("$format")
  valid_597031 = validateParameter(valid_597031, JString, required = false,
                                 default = nil)
  if valid_597031 != nil:
    section.add "$format", valid_597031
  var valid_597032 = query.getOrDefault("$apply")
  valid_597032 = validateParameter(valid_597032, JString, required = false,
                                 default = nil)
  if valid_597032 != nil:
    section.add "$apply", valid_597032
  var valid_597033 = query.getOrDefault("$filter")
  valid_597033 = validateParameter(valid_597033, JString, required = false,
                                 default = nil)
  if valid_597033 != nil:
    section.add "$filter", valid_597033
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_597034 = query.getOrDefault("apiVersion")
  valid_597034 = validateParameter(valid_597034, JString, required = true,
                                 default = nil)
  if valid_597034 != nil:
    section.add "apiVersion", valid_597034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597035: Call_EventsGetByType_597003; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an OData query for events
  ## 
  let valid = call_597035.validator(path, query, header, formData, body)
  let scheme = call_597035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597035.url(scheme.get, call_597035.host, call_597035.base,
                         call_597035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597035, url, valid)

proc call*(call_597036: Call_EventsGetByType_597003; resourceGroupName: string;
          applicationName: string; subscriptionId: string; apiVersion: string;
          Orderby: string = ""; timespan: string = ""; eventType: string = "$all";
          Top: int = 0; Select: string = ""; Skip: int = 0; Count: bool = false;
          Search: string = ""; Format: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## eventsGetByType
  ## Executes an OData query for events
  ##   Orderby: string
  ##          : A comma-separated list of properties with \"asc\" (the default) or \"desc\" to control the order of returned events
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   timespan: string
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   eventType: string (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  ##   Top: int
  ##      : The number of events to return
  ##   Select: string
  ##         : Limits the properties to just those requested on each returned event
  ##   Skip: int
  ##       : The number of items to skip over before returning events
  ##   Count: bool
  ##        : Request a count of matching items included with the returned events
  ##   Search: string
  ##         : A free-text search expression to match for whether a particular event should be returned
  ##   Format: string
  ##         : Format for the returned events
  ##   Apply: string
  ##        : An expression used for aggregation over returned events
  ##   Filter: string
  ##         : An expression used to filter the returned events
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_597037 = newJObject()
  var query_597038 = newJObject()
  add(query_597038, "$orderby", newJString(Orderby))
  add(path_597037, "resourceGroupName", newJString(resourceGroupName))
  add(path_597037, "applicationName", newJString(applicationName))
  add(query_597038, "timespan", newJString(timespan))
  add(path_597037, "subscriptionId", newJString(subscriptionId))
  add(path_597037, "eventType", newJString(eventType))
  add(query_597038, "$top", newJInt(Top))
  add(query_597038, "$select", newJString(Select))
  add(query_597038, "$skip", newJInt(Skip))
  add(query_597038, "$count", newJBool(Count))
  add(query_597038, "$search", newJString(Search))
  add(query_597038, "$format", newJString(Format))
  add(query_597038, "$apply", newJString(Apply))
  add(query_597038, "$filter", newJString(Filter))
  add(query_597038, "apiVersion", newJString(apiVersion))
  result = call_597036.call(path_597037, query_597038, nil, nil, nil)

var eventsGetByType* = Call_EventsGetByType_597003(name: "eventsGetByType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/{eventType}",
    validator: validate_EventsGetByType_597004, base: "", url: url_EventsGetByType_597005,
    schemes: {Scheme.Https})
type
  Call_EventsGet_597039 = ref object of OpenApiRestCall_596467
proc url_EventsGet_597041(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_EventsGet_597040(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the data for a single event
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   eventType: JString (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  ##   eventId: JString (required)
  ##          : ID of event.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597042 = path.getOrDefault("resourceGroupName")
  valid_597042 = validateParameter(valid_597042, JString, required = true,
                                 default = nil)
  if valid_597042 != nil:
    section.add "resourceGroupName", valid_597042
  var valid_597043 = path.getOrDefault("applicationName")
  valid_597043 = validateParameter(valid_597043, JString, required = true,
                                 default = nil)
  if valid_597043 != nil:
    section.add "applicationName", valid_597043
  var valid_597044 = path.getOrDefault("subscriptionId")
  valid_597044 = validateParameter(valid_597044, JString, required = true,
                                 default = nil)
  if valid_597044 != nil:
    section.add "subscriptionId", valid_597044
  var valid_597045 = path.getOrDefault("eventType")
  valid_597045 = validateParameter(valid_597045, JString, required = true,
                                 default = newJString("$all"))
  if valid_597045 != nil:
    section.add "eventType", valid_597045
  var valid_597046 = path.getOrDefault("eventId")
  valid_597046 = validateParameter(valid_597046, JString, required = true,
                                 default = nil)
  if valid_597046 != nil:
    section.add "eventId", valid_597046
  result.add "path", section
  ## parameters in `query` object:
  ##   timespan: JString
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_597047 = query.getOrDefault("timespan")
  valid_597047 = validateParameter(valid_597047, JString, required = false,
                                 default = nil)
  if valid_597047 != nil:
    section.add "timespan", valid_597047
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_597048 = query.getOrDefault("apiVersion")
  valid_597048 = validateParameter(valid_597048, JString, required = true,
                                 default = nil)
  if valid_597048 != nil:
    section.add "apiVersion", valid_597048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597049: Call_EventsGet_597039; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data for a single event
  ## 
  let valid = call_597049.validator(path, query, header, formData, body)
  let scheme = call_597049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597049.url(scheme.get, call_597049.host, call_597049.base,
                         call_597049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597049, url, valid)

proc call*(call_597050: Call_EventsGet_597039; resourceGroupName: string;
          applicationName: string; subscriptionId: string; eventId: string;
          apiVersion: string; timespan: string = ""; eventType: string = "$all"): Recallable =
  ## eventsGet
  ## Gets the data for a single event
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   timespan: string
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   eventType: string (required)
  ##            : The type of events to query; either a standard event type (`traces`, `customEvents`, `pageViews`, `requests`, `dependencies`, `exceptions`, `availabilityResults`) or `$all` to query across all event types.
  ##   eventId: string (required)
  ##          : ID of event.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_597051 = newJObject()
  var query_597052 = newJObject()
  add(path_597051, "resourceGroupName", newJString(resourceGroupName))
  add(path_597051, "applicationName", newJString(applicationName))
  add(query_597052, "timespan", newJString(timespan))
  add(path_597051, "subscriptionId", newJString(subscriptionId))
  add(path_597051, "eventType", newJString(eventType))
  add(path_597051, "eventId", newJString(eventId))
  add(query_597052, "apiVersion", newJString(apiVersion))
  result = call_597050.call(path_597051, query_597052, nil, nil, nil)

var eventsGet* = Call_EventsGet_597039(name: "eventsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/{eventType}/{eventId}",
                                    validator: validate_EventsGet_597040,
                                    base: "", url: url_EventsGet_597041,
                                    schemes: {Scheme.Https})
type
  Call_MetricsGetMetadata_597053 = ref object of OpenApiRestCall_596467
proc url_MetricsGetMetadata_597055(protocol: Scheme; host: string; base: string;
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

proc validate_MetricsGetMetadata_597054(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets metadata describing the available metrics
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597056 = path.getOrDefault("resourceGroupName")
  valid_597056 = validateParameter(valid_597056, JString, required = true,
                                 default = nil)
  if valid_597056 != nil:
    section.add "resourceGroupName", valid_597056
  var valid_597057 = path.getOrDefault("applicationName")
  valid_597057 = validateParameter(valid_597057, JString, required = true,
                                 default = nil)
  if valid_597057 != nil:
    section.add "applicationName", valid_597057
  var valid_597058 = path.getOrDefault("subscriptionId")
  valid_597058 = validateParameter(valid_597058, JString, required = true,
                                 default = nil)
  if valid_597058 != nil:
    section.add "subscriptionId", valid_597058
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_597059 = query.getOrDefault("apiVersion")
  valid_597059 = validateParameter(valid_597059, JString, required = true,
                                 default = nil)
  if valid_597059 != nil:
    section.add "apiVersion", valid_597059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597060: Call_MetricsGetMetadata_597053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets metadata describing the available metrics
  ## 
  let valid = call_597060.validator(path, query, header, formData, body)
  let scheme = call_597060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597060.url(scheme.get, call_597060.host, call_597060.base,
                         call_597060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597060, url, valid)

proc call*(call_597061: Call_MetricsGetMetadata_597053; resourceGroupName: string;
          applicationName: string; subscriptionId: string; apiVersion: string): Recallable =
  ## metricsGetMetadata
  ## Gets metadata describing the available metrics
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_597062 = newJObject()
  var query_597063 = newJObject()
  add(path_597062, "resourceGroupName", newJString(resourceGroupName))
  add(path_597062, "applicationName", newJString(applicationName))
  add(path_597062, "subscriptionId", newJString(subscriptionId))
  add(query_597063, "apiVersion", newJString(apiVersion))
  result = call_597061.call(path_597062, query_597063, nil, nil, nil)

var metricsGetMetadata* = Call_MetricsGetMetadata_597053(
    name: "metricsGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/metrics/metadata",
    validator: validate_MetricsGetMetadata_597054, base: "",
    url: url_MetricsGetMetadata_597055, schemes: {Scheme.Https})
type
  Call_MetricsGet_597064 = ref object of OpenApiRestCall_596467
proc url_MetricsGet_597066(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_MetricsGet_597065(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets metric values for a single metric
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   metricId: JString (required)
  ##           : ID of the metric. This is either a standard AI metric, or an application-specific custom metric.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597067 = path.getOrDefault("resourceGroupName")
  valid_597067 = validateParameter(valid_597067, JString, required = true,
                                 default = nil)
  if valid_597067 != nil:
    section.add "resourceGroupName", valid_597067
  var valid_597068 = path.getOrDefault("applicationName")
  valid_597068 = validateParameter(valid_597068, JString, required = true,
                                 default = nil)
  if valid_597068 != nil:
    section.add "applicationName", valid_597068
  var valid_597069 = path.getOrDefault("metricId")
  valid_597069 = validateParameter(valid_597069, JString, required = true,
                                 default = newJString("requests/count"))
  if valid_597069 != nil:
    section.add "metricId", valid_597069
  var valid_597070 = path.getOrDefault("subscriptionId")
  valid_597070 = validateParameter(valid_597070, JString, required = true,
                                 default = nil)
  if valid_597070 != nil:
    section.add "subscriptionId", valid_597070
  result.add "path", section
  ## parameters in `query` object:
  ##   segment: JArray
  ##          : The name of the dimension to segment the metric values by. This dimension must be applicable to the metric you are retrieving. To segment by more than one dimension at a time, separate them with a comma (,). In this case, the metric data will be segmented in the order the dimensions are listed in the parameter.
  ##   orderby: JString
  ##          : The aggregation function and direction to sort the segments by.  This value is only valid when segment is specified.
  ##   timespan: JString
  ##           : The timespan over which to retrieve metric values. This is an ISO8601 time period value. If timespan is omitted, a default time range of `PT12H` ("last 12 hours") is used. The actual timespan that is queried may be adjusted by the server based. In all cases, the actual time span used for the query is included in the response.
  ##   top: JInt
  ##      : The number of segments to return.  This value is only valid when segment is specified.
  ##   interval: JString
  ##           : The time interval to use when retrieving metric values. This is an ISO8601 duration. If interval is omitted, the metric value is aggregated across the entire timespan. If interval is supplied, the server may adjust the interval to a more appropriate size based on the timespan used for the query. In all cases, the actual interval used for the query is included in the response.
  ##   aggregation: JArray
  ##              : The aggregation to use when computing the metric values. To retrieve more than one aggregation at a time, separate them with a comma. If no aggregation is specified, then the default aggregation for the metric is used.
  ##   filter: JString
  ##         : An expression used to filter the results.  This value should be a valid OData filter expression where the keys of each clause should be applicable dimensions for the metric you are retrieving.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_597071 = query.getOrDefault("segment")
  valid_597071 = validateParameter(valid_597071, JArray, required = false,
                                 default = nil)
  if valid_597071 != nil:
    section.add "segment", valid_597071
  var valid_597072 = query.getOrDefault("orderby")
  valid_597072 = validateParameter(valid_597072, JString, required = false,
                                 default = nil)
  if valid_597072 != nil:
    section.add "orderby", valid_597072
  var valid_597073 = query.getOrDefault("timespan")
  valid_597073 = validateParameter(valid_597073, JString, required = false,
                                 default = nil)
  if valid_597073 != nil:
    section.add "timespan", valid_597073
  var valid_597074 = query.getOrDefault("top")
  valid_597074 = validateParameter(valid_597074, JInt, required = false, default = nil)
  if valid_597074 != nil:
    section.add "top", valid_597074
  var valid_597075 = query.getOrDefault("interval")
  valid_597075 = validateParameter(valid_597075, JString, required = false,
                                 default = nil)
  if valid_597075 != nil:
    section.add "interval", valid_597075
  var valid_597076 = query.getOrDefault("aggregation")
  valid_597076 = validateParameter(valid_597076, JArray, required = false,
                                 default = nil)
  if valid_597076 != nil:
    section.add "aggregation", valid_597076
  var valid_597077 = query.getOrDefault("filter")
  valid_597077 = validateParameter(valid_597077, JString, required = false,
                                 default = nil)
  if valid_597077 != nil:
    section.add "filter", valid_597077
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_597078 = query.getOrDefault("apiVersion")
  valid_597078 = validateParameter(valid_597078, JString, required = true,
                                 default = nil)
  if valid_597078 != nil:
    section.add "apiVersion", valid_597078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597079: Call_MetricsGet_597064; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets metric values for a single metric
  ## 
  let valid = call_597079.validator(path, query, header, formData, body)
  let scheme = call_597079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597079.url(scheme.get, call_597079.host, call_597079.base,
                         call_597079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597079, url, valid)

proc call*(call_597080: Call_MetricsGet_597064; resourceGroupName: string;
          applicationName: string; subscriptionId: string; apiVersion: string;
          metricId: string = "requests/count"; segment: JsonNode = nil;
          orderby: string = ""; timespan: string = ""; top: int = 0; interval: string = "";
          aggregation: JsonNode = nil; filter: string = ""): Recallable =
  ## metricsGet
  ## Gets metric values for a single metric
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   metricId: string (required)
  ##           : ID of the metric. This is either a standard AI metric, or an application-specific custom metric.
  ##   segment: JArray
  ##          : The name of the dimension to segment the metric values by. This dimension must be applicable to the metric you are retrieving. To segment by more than one dimension at a time, separate them with a comma (,). In this case, the metric data will be segmented in the order the dimensions are listed in the parameter.
  ##   orderby: string
  ##          : The aggregation function and direction to sort the segments by.  This value is only valid when segment is specified.
  ##   timespan: string
  ##           : The timespan over which to retrieve metric values. This is an ISO8601 time period value. If timespan is omitted, a default time range of `PT12H` ("last 12 hours") is used. The actual timespan that is queried may be adjusted by the server based. In all cases, the actual time span used for the query is included in the response.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   top: int
  ##      : The number of segments to return.  This value is only valid when segment is specified.
  ##   interval: string
  ##           : The time interval to use when retrieving metric values. This is an ISO8601 duration. If interval is omitted, the metric value is aggregated across the entire timespan. If interval is supplied, the server may adjust the interval to a more appropriate size based on the timespan used for the query. In all cases, the actual interval used for the query is included in the response.
  ##   aggregation: JArray
  ##              : The aggregation to use when computing the metric values. To retrieve more than one aggregation at a time, separate them with a comma. If no aggregation is specified, then the default aggregation for the metric is used.
  ##   filter: string
  ##         : An expression used to filter the results.  This value should be a valid OData filter expression where the keys of each clause should be applicable dimensions for the metric you are retrieving.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_597081 = newJObject()
  var query_597082 = newJObject()
  add(path_597081, "resourceGroupName", newJString(resourceGroupName))
  add(path_597081, "applicationName", newJString(applicationName))
  add(path_597081, "metricId", newJString(metricId))
  if segment != nil:
    query_597082.add "segment", segment
  add(query_597082, "orderby", newJString(orderby))
  add(query_597082, "timespan", newJString(timespan))
  add(path_597081, "subscriptionId", newJString(subscriptionId))
  add(query_597082, "top", newJInt(top))
  add(query_597082, "interval", newJString(interval))
  if aggregation != nil:
    query_597082.add "aggregation", aggregation
  add(query_597082, "filter", newJString(filter))
  add(query_597082, "apiVersion", newJString(apiVersion))
  result = call_597080.call(path_597081, query_597082, nil, nil, nil)

var metricsGet* = Call_MetricsGet_597064(name: "metricsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/metrics/{metricId}",
                                      validator: validate_MetricsGet_597065,
                                      base: "", url: url_MetricsGet_597066,
                                      schemes: {Scheme.Https})
type
  Call_QueryExecute_597096 = ref object of OpenApiRestCall_596467
proc url_QueryExecute_597098(protocol: Scheme; host: string; base: string;
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

proc validate_QueryExecute_597097(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597099 = path.getOrDefault("resourceGroupName")
  valid_597099 = validateParameter(valid_597099, JString, required = true,
                                 default = nil)
  if valid_597099 != nil:
    section.add "resourceGroupName", valid_597099
  var valid_597100 = path.getOrDefault("applicationName")
  valid_597100 = validateParameter(valid_597100, JString, required = true,
                                 default = nil)
  if valid_597100 != nil:
    section.add "applicationName", valid_597100
  var valid_597101 = path.getOrDefault("subscriptionId")
  valid_597101 = validateParameter(valid_597101, JString, required = true,
                                 default = nil)
  if valid_597101 != nil:
    section.add "subscriptionId", valid_597101
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_597102 = query.getOrDefault("apiVersion")
  valid_597102 = validateParameter(valid_597102, JString, required = true,
                                 default = nil)
  if valid_597102 != nil:
    section.add "apiVersion", valid_597102
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

proc call*(call_597104: Call_QueryExecute_597096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ## 
  let valid = call_597104.validator(path, query, header, formData, body)
  let scheme = call_597104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597104.url(scheme.get, call_597104.host, call_597104.base,
                         call_597104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597104, url, valid)

proc call*(call_597105: Call_QueryExecute_597096; resourceGroupName: string;
          applicationName: string; subscriptionId: string; body: JsonNode;
          apiVersion: string): Recallable =
  ## queryExecute
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_597106 = newJObject()
  var query_597107 = newJObject()
  var body_597108 = newJObject()
  add(path_597106, "resourceGroupName", newJString(resourceGroupName))
  add(path_597106, "applicationName", newJString(applicationName))
  add(path_597106, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_597108 = body
  add(query_597107, "apiVersion", newJString(apiVersion))
  result = call_597105.call(path_597106, query_597107, nil, nil, body_597108)

var queryExecute* = Call_QueryExecute_597096(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/query",
    validator: validate_QueryExecute_597097, base: "", url: url_QueryExecute_597098,
    schemes: {Scheme.Https})
type
  Call_QueryGet_597083 = ref object of OpenApiRestCall_596467
proc url_QueryGet_597085(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueryGet_597084(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an Analytics query for data
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: JString (required)
  ##                  : Name of the Application Insights application.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_597086 = path.getOrDefault("resourceGroupName")
  valid_597086 = validateParameter(valid_597086, JString, required = true,
                                 default = nil)
  if valid_597086 != nil:
    section.add "resourceGroupName", valid_597086
  var valid_597087 = path.getOrDefault("applicationName")
  valid_597087 = validateParameter(valid_597087, JString, required = true,
                                 default = nil)
  if valid_597087 != nil:
    section.add "applicationName", valid_597087
  var valid_597088 = path.getOrDefault("subscriptionId")
  valid_597088 = validateParameter(valid_597088, JString, required = true,
                                 default = nil)
  if valid_597088 != nil:
    section.add "subscriptionId", valid_597088
  result.add "path", section
  ## parameters in `query` object:
  ##   query: JString (required)
  ##        : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   timespan: JString
  ##           : Optional. The timespan over which to query data. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the query expression.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `query` field"
  var valid_597089 = query.getOrDefault("query")
  valid_597089 = validateParameter(valid_597089, JString, required = true,
                                 default = nil)
  if valid_597089 != nil:
    section.add "query", valid_597089
  var valid_597090 = query.getOrDefault("timespan")
  valid_597090 = validateParameter(valid_597090, JString, required = false,
                                 default = nil)
  if valid_597090 != nil:
    section.add "timespan", valid_597090
  var valid_597091 = query.getOrDefault("apiVersion")
  valid_597091 = validateParameter(valid_597091, JString, required = true,
                                 default = nil)
  if valid_597091 != nil:
    section.add "apiVersion", valid_597091
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597092: Call_QueryGet_597083; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data
  ## 
  let valid = call_597092.validator(path, query, header, formData, body)
  let scheme = call_597092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597092.url(scheme.get, call_597092.host, call_597092.base,
                         call_597092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597092, url, valid)

proc call*(call_597093: Call_QueryGet_597083; resourceGroupName: string;
          applicationName: string; query: string; subscriptionId: string;
          apiVersion: string; timespan: string = ""): Recallable =
  ## queryGet
  ## Executes an Analytics query for data
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   applicationName: string (required)
  ##                  : Name of the Application Insights application.
  ##   query: string (required)
  ##        : The Analytics query. Learn more about the [Analytics query 
  ## syntax](https://azure.microsoft.com/documentation/articles/app-insights-analytics-reference/)
  ##   timespan: string
  ##           : Optional. The timespan over which to query data. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the query expression.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var path_597094 = newJObject()
  var query_597095 = newJObject()
  add(path_597094, "resourceGroupName", newJString(resourceGroupName))
  add(path_597094, "applicationName", newJString(applicationName))
  add(query_597095, "query", newJString(query))
  add(query_597095, "timespan", newJString(timespan))
  add(path_597094, "subscriptionId", newJString(subscriptionId))
  add(query_597095, "apiVersion", newJString(apiVersion))
  result = call_597093.call(path_597094, query_597095, nil, nil, nil)

var queryGet* = Call_QueryGet_597083(name: "queryGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/query",
                                  validator: validate_QueryGet_597084, base: "",
                                  url: url_QueryGet_597085,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

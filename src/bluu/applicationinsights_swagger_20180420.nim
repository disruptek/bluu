
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593438 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593438](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593438): Option[Scheme] {.used.} =
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
  macServiceName = "applicationinsights-swagger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EventsGetOdataMetadata_593660 = ref object of OpenApiRestCall_593438
proc url_EventsGetOdataMetadata_593662(protocol: Scheme; host: string; base: string;
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

proc validate_EventsGetOdataMetadata_593661(path: JsonNode; query: JsonNode;
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
  var valid_593835 = path.getOrDefault("resourceGroupName")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = nil)
  if valid_593835 != nil:
    section.add "resourceGroupName", valid_593835
  var valid_593836 = path.getOrDefault("applicationName")
  valid_593836 = validateParameter(valid_593836, JString, required = true,
                                 default = nil)
  if valid_593836 != nil:
    section.add "applicationName", valid_593836
  var valid_593837 = path.getOrDefault("subscriptionId")
  valid_593837 = validateParameter(valid_593837, JString, required = true,
                                 default = nil)
  if valid_593837 != nil:
    section.add "subscriptionId", valid_593837
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_593838 = query.getOrDefault("apiVersion")
  valid_593838 = validateParameter(valid_593838, JString, required = true,
                                 default = nil)
  if valid_593838 != nil:
    section.add "apiVersion", valid_593838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593861: Call_EventsGetOdataMetadata_593660; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData EDMX metadata describing the event data model
  ## 
  let valid = call_593861.validator(path, query, header, formData, body)
  let scheme = call_593861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593861.url(scheme.get, call_593861.host, call_593861.base,
                         call_593861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593861, url, valid)

proc call*(call_593932: Call_EventsGetOdataMetadata_593660;
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
  var path_593933 = newJObject()
  var query_593935 = newJObject()
  add(path_593933, "resourceGroupName", newJString(resourceGroupName))
  add(path_593933, "applicationName", newJString(applicationName))
  add(path_593933, "subscriptionId", newJString(subscriptionId))
  add(query_593935, "apiVersion", newJString(apiVersion))
  result = call_593932.call(path_593933, query_593935, nil, nil, nil)

var eventsGetOdataMetadata* = Call_EventsGetOdataMetadata_593660(
    name: "eventsGetOdataMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/$metadata",
    validator: validate_EventsGetOdataMetadata_593661, base: "",
    url: url_EventsGetOdataMetadata_593662, schemes: {Scheme.Https})
type
  Call_EventsGetByType_593974 = ref object of OpenApiRestCall_593438
proc url_EventsGetByType_593976(protocol: Scheme; host: string; base: string;
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

proc validate_EventsGetByType_593975(path: JsonNode; query: JsonNode;
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
  var valid_593978 = path.getOrDefault("resourceGroupName")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceGroupName", valid_593978
  var valid_593979 = path.getOrDefault("applicationName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "applicationName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  var valid_593994 = path.getOrDefault("eventType")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("$all"))
  if valid_593994 != nil:
    section.add "eventType", valid_593994
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
  var valid_593995 = query.getOrDefault("$orderby")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "$orderby", valid_593995
  var valid_593996 = query.getOrDefault("timespan")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "timespan", valid_593996
  var valid_593997 = query.getOrDefault("$top")
  valid_593997 = validateParameter(valid_593997, JInt, required = false, default = nil)
  if valid_593997 != nil:
    section.add "$top", valid_593997
  var valid_593998 = query.getOrDefault("$select")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "$select", valid_593998
  var valid_593999 = query.getOrDefault("$skip")
  valid_593999 = validateParameter(valid_593999, JInt, required = false, default = nil)
  if valid_593999 != nil:
    section.add "$skip", valid_593999
  var valid_594000 = query.getOrDefault("$count")
  valid_594000 = validateParameter(valid_594000, JBool, required = false, default = nil)
  if valid_594000 != nil:
    section.add "$count", valid_594000
  var valid_594001 = query.getOrDefault("$search")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "$search", valid_594001
  var valid_594002 = query.getOrDefault("$format")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "$format", valid_594002
  var valid_594003 = query.getOrDefault("$apply")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "$apply", valid_594003
  var valid_594004 = query.getOrDefault("$filter")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "$filter", valid_594004
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_594005 = query.getOrDefault("apiVersion")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "apiVersion", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_EventsGetByType_593974; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an OData query for events
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_EventsGetByType_593974; resourceGroupName: string;
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
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(query_594009, "$orderby", newJString(Orderby))
  add(path_594008, "resourceGroupName", newJString(resourceGroupName))
  add(path_594008, "applicationName", newJString(applicationName))
  add(query_594009, "timespan", newJString(timespan))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "eventType", newJString(eventType))
  add(query_594009, "$top", newJInt(Top))
  add(query_594009, "$select", newJString(Select))
  add(query_594009, "$skip", newJInt(Skip))
  add(query_594009, "$count", newJBool(Count))
  add(query_594009, "$search", newJString(Search))
  add(query_594009, "$format", newJString(Format))
  add(query_594009, "$apply", newJString(Apply))
  add(query_594009, "$filter", newJString(Filter))
  add(query_594009, "apiVersion", newJString(apiVersion))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var eventsGetByType* = Call_EventsGetByType_593974(name: "eventsGetByType",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/{eventType}",
    validator: validate_EventsGetByType_593975, base: "", url: url_EventsGetByType_593976,
    schemes: {Scheme.Https})
type
  Call_EventsGet_594010 = ref object of OpenApiRestCall_593438
proc url_EventsGet_594012(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_EventsGet_594011(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594013 = path.getOrDefault("resourceGroupName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "resourceGroupName", valid_594013
  var valid_594014 = path.getOrDefault("applicationName")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "applicationName", valid_594014
  var valid_594015 = path.getOrDefault("subscriptionId")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "subscriptionId", valid_594015
  var valid_594016 = path.getOrDefault("eventType")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = newJString("$all"))
  if valid_594016 != nil:
    section.add "eventType", valid_594016
  var valid_594017 = path.getOrDefault("eventId")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = nil)
  if valid_594017 != nil:
    section.add "eventId", valid_594017
  result.add "path", section
  ## parameters in `query` object:
  ##   timespan: JString
  ##           : Optional. The timespan over which to retrieve events. This is an ISO8601 time period value.  This timespan is applied in addition to any that are specified in the Odata expression.
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  var valid_594018 = query.getOrDefault("timespan")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "timespan", valid_594018
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_594019 = query.getOrDefault("apiVersion")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "apiVersion", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_EventsGet_594010; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the data for a single event
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_EventsGet_594010; resourceGroupName: string;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(path_594022, "applicationName", newJString(applicationName))
  add(query_594023, "timespan", newJString(timespan))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  add(path_594022, "eventType", newJString(eventType))
  add(path_594022, "eventId", newJString(eventId))
  add(query_594023, "apiVersion", newJString(apiVersion))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var eventsGet* = Call_EventsGet_594010(name: "eventsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/events/{eventType}/{eventId}",
                                    validator: validate_EventsGet_594011,
                                    base: "", url: url_EventsGet_594012,
                                    schemes: {Scheme.Https})
type
  Call_MetricsGetMetadata_594024 = ref object of OpenApiRestCall_593438
proc url_MetricsGetMetadata_594026(protocol: Scheme; host: string; base: string;
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

proc validate_MetricsGetMetadata_594025(path: JsonNode; query: JsonNode;
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
  var valid_594027 = path.getOrDefault("resourceGroupName")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceGroupName", valid_594027
  var valid_594028 = path.getOrDefault("applicationName")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "applicationName", valid_594028
  var valid_594029 = path.getOrDefault("subscriptionId")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "subscriptionId", valid_594029
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_594030 = query.getOrDefault("apiVersion")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "apiVersion", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_MetricsGetMetadata_594024; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets metadata describing the available metrics
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_MetricsGetMetadata_594024; resourceGroupName: string;
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
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(path_594033, "resourceGroupName", newJString(resourceGroupName))
  add(path_594033, "applicationName", newJString(applicationName))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  add(query_594034, "apiVersion", newJString(apiVersion))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var metricsGetMetadata* = Call_MetricsGetMetadata_594024(
    name: "metricsGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/metrics/metadata",
    validator: validate_MetricsGetMetadata_594025, base: "",
    url: url_MetricsGetMetadata_594026, schemes: {Scheme.Https})
type
  Call_MetricsGet_594035 = ref object of OpenApiRestCall_593438
proc url_MetricsGet_594037(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_MetricsGet_594036(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594038 = path.getOrDefault("resourceGroupName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "resourceGroupName", valid_594038
  var valid_594039 = path.getOrDefault("applicationName")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "applicationName", valid_594039
  var valid_594040 = path.getOrDefault("metricId")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = newJString("requests/count"))
  if valid_594040 != nil:
    section.add "metricId", valid_594040
  var valid_594041 = path.getOrDefault("subscriptionId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "subscriptionId", valid_594041
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
  var valid_594042 = query.getOrDefault("segment")
  valid_594042 = validateParameter(valid_594042, JArray, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "segment", valid_594042
  var valid_594043 = query.getOrDefault("orderby")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "orderby", valid_594043
  var valid_594044 = query.getOrDefault("timespan")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "timespan", valid_594044
  var valid_594045 = query.getOrDefault("top")
  valid_594045 = validateParameter(valid_594045, JInt, required = false, default = nil)
  if valid_594045 != nil:
    section.add "top", valid_594045
  var valid_594046 = query.getOrDefault("interval")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "interval", valid_594046
  var valid_594047 = query.getOrDefault("aggregation")
  valid_594047 = validateParameter(valid_594047, JArray, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "aggregation", valid_594047
  var valid_594048 = query.getOrDefault("filter")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "filter", valid_594048
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_594049 = query.getOrDefault("apiVersion")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "apiVersion", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_MetricsGet_594035; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets metric values for a single metric
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_MetricsGet_594035; resourceGroupName: string;
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
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(path_594052, "resourceGroupName", newJString(resourceGroupName))
  add(path_594052, "applicationName", newJString(applicationName))
  add(path_594052, "metricId", newJString(metricId))
  if segment != nil:
    query_594053.add "segment", segment
  add(query_594053, "orderby", newJString(orderby))
  add(query_594053, "timespan", newJString(timespan))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(query_594053, "top", newJInt(top))
  add(query_594053, "interval", newJString(interval))
  if aggregation != nil:
    query_594053.add "aggregation", aggregation
  add(query_594053, "filter", newJString(filter))
  add(query_594053, "apiVersion", newJString(apiVersion))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var metricsGet* = Call_MetricsGet_594035(name: "metricsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/metrics/{metricId}",
                                      validator: validate_MetricsGet_594036,
                                      base: "", url: url_MetricsGet_594037,
                                      schemes: {Scheme.Https})
type
  Call_QueryExecute_594067 = ref object of OpenApiRestCall_593438
proc url_QueryExecute_594069(protocol: Scheme; host: string; base: string;
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

proc validate_QueryExecute_594068(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594070 = path.getOrDefault("resourceGroupName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "resourceGroupName", valid_594070
  var valid_594071 = path.getOrDefault("applicationName")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "applicationName", valid_594071
  var valid_594072 = path.getOrDefault("subscriptionId")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "subscriptionId", valid_594072
  result.add "path", section
  ## parameters in `query` object:
  ##   apiVersion: JString (required)
  ##             : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `apiVersion` field"
  var valid_594073 = query.getOrDefault("apiVersion")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "apiVersion", valid_594073
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

proc call*(call_594075: Call_QueryExecute_594067; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data. [Here](https://dev.applicationinsights.io/documentation/Using-the-API/Query) is an example for using POST with an Analytics query.
  ## 
  let valid = call_594075.validator(path, query, header, formData, body)
  let scheme = call_594075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594075.url(scheme.get, call_594075.host, call_594075.base,
                         call_594075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594075, url, valid)

proc call*(call_594076: Call_QueryExecute_594067; resourceGroupName: string;
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
  var path_594077 = newJObject()
  var query_594078 = newJObject()
  var body_594079 = newJObject()
  add(path_594077, "resourceGroupName", newJString(resourceGroupName))
  add(path_594077, "applicationName", newJString(applicationName))
  add(path_594077, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_594079 = body
  add(query_594078, "apiVersion", newJString(apiVersion))
  result = call_594076.call(path_594077, query_594078, nil, nil, body_594079)

var queryExecute* = Call_QueryExecute_594067(name: "queryExecute",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/query",
    validator: validate_QueryExecute_594068, base: "", url: url_QueryExecute_594069,
    schemes: {Scheme.Https})
type
  Call_QueryGet_594054 = ref object of OpenApiRestCall_593438
proc url_QueryGet_594056(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_QueryGet_594055(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594057 = path.getOrDefault("resourceGroupName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "resourceGroupName", valid_594057
  var valid_594058 = path.getOrDefault("applicationName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "applicationName", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
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
  var valid_594060 = query.getOrDefault("query")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "query", valid_594060
  var valid_594061 = query.getOrDefault("timespan")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "timespan", valid_594061
  var valid_594062 = query.getOrDefault("apiVersion")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "apiVersion", valid_594062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594063: Call_QueryGet_594054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an Analytics query for data
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_QueryGet_594054; resourceGroupName: string;
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
  var path_594065 = newJObject()
  var query_594066 = newJObject()
  add(path_594065, "resourceGroupName", newJString(resourceGroupName))
  add(path_594065, "applicationName", newJString(applicationName))
  add(query_594066, "query", newJString(query))
  add(query_594066, "timespan", newJString(timespan))
  add(path_594065, "subscriptionId", newJString(subscriptionId))
  add(query_594066, "apiVersion", newJString(apiVersion))
  result = call_594064.call(path_594065, query_594066, nil, nil, nil)

var queryGet* = Call_QueryGet_594054(name: "queryGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Insights/components/{applicationName}/query",
                                  validator: validate_QueryGet_594055, base: "",
                                  url: url_QueryGet_594056,
                                  schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

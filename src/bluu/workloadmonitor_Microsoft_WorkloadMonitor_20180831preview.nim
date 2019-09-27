
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Workload Monitor
## version: 2018-08-31-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs for workload monitoring
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
  macServiceName = "workloadmonitor-Microsoft.WorkloadMonitor"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593647 = ref object of OpenApiRestCall_593425
proc url_OperationsList_593649(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593648(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593822 = query.getOrDefault("api-version")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_593822 != nil:
    section.add "api-version", valid_593822
  var valid_593823 = query.getOrDefault("$skiptoken")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "$skiptoken", valid_593823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593846: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593846.validator(path, query, header, formData, body)
  let scheme = call_593846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593846.url(scheme.get, call_593846.host, call_593846.base,
                         call_593846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593846, url, valid)

proc call*(call_593917: Call_OperationsList_593647;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = ""): Recallable =
  ## operationsList
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  var query_593918 = newJObject()
  add(query_593918, "api-version", newJString(apiVersion))
  add(query_593918, "$skiptoken", newJString(Skiptoken))
  result = call_593917.call(nil, query_593918, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.WorkloadMonitor/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_ComponentsSummaryList_593958 = ref object of OpenApiRestCall_593425
proc url_ComponentsSummaryList_593960(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/componentsSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsSummaryList_593959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593975 = path.getOrDefault("subscriptionId")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "subscriptionId", valid_593975
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_593976 = query.getOrDefault("$orderby")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "$orderby", valid_593976
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593977 = query.getOrDefault("api-version")
  valid_593977 = validateParameter(valid_593977, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_593977 != nil:
    section.add "api-version", valid_593977
  var valid_593978 = query.getOrDefault("$expand")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "$expand", valid_593978
  var valid_593979 = query.getOrDefault("$top")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$top", valid_593979
  var valid_593980 = query.getOrDefault("$select")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "$select", valid_593980
  var valid_593981 = query.getOrDefault("$skiptoken")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "$skiptoken", valid_593981
  var valid_593982 = query.getOrDefault("$apply")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "$apply", valid_593982
  var valid_593983 = query.getOrDefault("$filter")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "$filter", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_ComponentsSummaryList_593958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ComponentsSummaryList_593958; subscriptionId: string;
          Orderby: string = ""; apiVersion: string = "2018-08-31-preview";
          Expand: string = ""; Top: string = ""; Select: string = "";
          Skiptoken: string = ""; Apply: string = ""; Filter: string = ""): Recallable =
  ## componentsSummaryList
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(query_593987, "$orderby", newJString(Orderby))
  add(query_593987, "api-version", newJString(apiVersion))
  add(query_593987, "$expand", newJString(Expand))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(query_593987, "$top", newJString(Top))
  add(query_593987, "$select", newJString(Select))
  add(query_593987, "$skiptoken", newJString(Skiptoken))
  add(query_593987, "$apply", newJString(Apply))
  add(query_593987, "$filter", newJString(Filter))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var componentsSummaryList* = Call_ComponentsSummaryList_593958(
    name: "componentsSummaryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.WorkloadMonitor/componentsSummary",
    validator: validate_ComponentsSummaryList_593959, base: "",
    url: url_ComponentsSummaryList_593960, schemes: {Scheme.Https})
type
  Call_MonitorInstancesSummaryList_593988 = ref object of OpenApiRestCall_593425
proc url_MonitorInstancesSummaryList_593990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitorInstancesSummary")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorInstancesSummaryList_593989(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_593992 = query.getOrDefault("$orderby")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "$orderby", valid_593992
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  var valid_593994 = query.getOrDefault("$expand")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "$expand", valid_593994
  var valid_593995 = query.getOrDefault("$top")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "$top", valid_593995
  var valid_593996 = query.getOrDefault("$select")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$select", valid_593996
  var valid_593997 = query.getOrDefault("$skiptoken")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "$skiptoken", valid_593997
  var valid_593998 = query.getOrDefault("$apply")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "$apply", valid_593998
  var valid_593999 = query.getOrDefault("$filter")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "$filter", valid_593999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594000: Call_MonitorInstancesSummaryList_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_MonitorInstancesSummaryList_593988;
          subscriptionId: string; Orderby: string = "";
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Top: string = ""; Select: string = ""; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## monitorInstancesSummaryList
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(query_594003, "$orderby", newJString(Orderby))
  add(query_594003, "api-version", newJString(apiVersion))
  add(query_594003, "$expand", newJString(Expand))
  add(path_594002, "subscriptionId", newJString(subscriptionId))
  add(query_594003, "$top", newJString(Top))
  add(query_594003, "$select", newJString(Select))
  add(query_594003, "$skiptoken", newJString(Skiptoken))
  add(query_594003, "$apply", newJString(Apply))
  add(query_594003, "$filter", newJString(Filter))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var monitorInstancesSummaryList* = Call_MonitorInstancesSummaryList_593988(
    name: "monitorInstancesSummaryList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.WorkloadMonitor/monitorInstancesSummary",
    validator: validate_MonitorInstancesSummaryList_593989, base: "",
    url: url_MonitorInstancesSummaryList_593990, schemes: {Scheme.Https})
type
  Call_ComponentsListByResource_594004 = ref object of OpenApiRestCall_593425
proc url_ComponentsListByResource_594006(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/components")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsListByResource_594005(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594007 = path.getOrDefault("resourceType")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "resourceType", valid_594007
  var valid_594008 = path.getOrDefault("resourceGroupName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "resourceGroupName", valid_594008
  var valid_594009 = path.getOrDefault("subscriptionId")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "subscriptionId", valid_594009
  var valid_594010 = path.getOrDefault("resourceName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceName", valid_594010
  var valid_594011 = path.getOrDefault("resourceNamespace")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceNamespace", valid_594011
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_594012 = query.getOrDefault("$orderby")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "$orderby", valid_594012
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594013 = query.getOrDefault("api-version")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594013 != nil:
    section.add "api-version", valid_594013
  var valid_594014 = query.getOrDefault("$expand")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "$expand", valid_594014
  var valid_594015 = query.getOrDefault("$top")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "$top", valid_594015
  var valid_594016 = query.getOrDefault("$select")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "$select", valid_594016
  var valid_594017 = query.getOrDefault("$skiptoken")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "$skiptoken", valid_594017
  var valid_594018 = query.getOrDefault("$apply")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "$apply", valid_594018
  var valid_594019 = query.getOrDefault("$filter")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "$filter", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_ComponentsListByResource_594004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_ComponentsListByResource_594004; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; Orderby: string = "";
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Top: string = ""; Select: string = ""; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## componentsListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(path_594022, "resourceType", newJString(resourceType))
  add(query_594023, "$orderby", newJString(Orderby))
  add(path_594022, "resourceGroupName", newJString(resourceGroupName))
  add(query_594023, "api-version", newJString(apiVersion))
  add(query_594023, "$expand", newJString(Expand))
  add(path_594022, "subscriptionId", newJString(subscriptionId))
  add(query_594023, "$top", newJString(Top))
  add(path_594022, "resourceName", newJString(resourceName))
  add(query_594023, "$select", newJString(Select))
  add(path_594022, "resourceNamespace", newJString(resourceNamespace))
  add(query_594023, "$skiptoken", newJString(Skiptoken))
  add(query_594023, "$apply", newJString(Apply))
  add(query_594023, "$filter", newJString(Filter))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var componentsListByResource* = Call_ComponentsListByResource_594004(
    name: "componentsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/components",
    validator: validate_ComponentsListByResource_594005, base: "",
    url: url_ComponentsListByResource_594006, schemes: {Scheme.Https})
type
  Call_ComponentsGet_594024 = ref object of OpenApiRestCall_593425
proc url_ComponentsGet_594026(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "componentId" in path, "`componentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/components/"),
               (kind: VariableSegment, value: "componentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ComponentsGet_594025(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   componentId: JString (required)
  ##              : Component Id.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594027 = path.getOrDefault("resourceType")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "resourceType", valid_594027
  var valid_594028 = path.getOrDefault("componentId")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = nil)
  if valid_594028 != nil:
    section.add "componentId", valid_594028
  var valid_594029 = path.getOrDefault("resourceGroupName")
  valid_594029 = validateParameter(valid_594029, JString, required = true,
                                 default = nil)
  if valid_594029 != nil:
    section.add "resourceGroupName", valid_594029
  var valid_594030 = path.getOrDefault("subscriptionId")
  valid_594030 = validateParameter(valid_594030, JString, required = true,
                                 default = nil)
  if valid_594030 != nil:
    section.add "subscriptionId", valid_594030
  var valid_594031 = path.getOrDefault("resourceName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceName", valid_594031
  var valid_594032 = path.getOrDefault("resourceNamespace")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "resourceNamespace", valid_594032
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  var valid_594034 = query.getOrDefault("$expand")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "$expand", valid_594034
  var valid_594035 = query.getOrDefault("$select")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "$select", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_ComponentsGet_594024; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_ComponentsGet_594024; resourceType: string;
          componentId: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string;
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Select: string = ""): Recallable =
  ## componentsGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   componentId: string (required)
  ##              : Component Id.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(path_594038, "resourceType", newJString(resourceType))
  add(path_594038, "componentId", newJString(componentId))
  add(path_594038, "resourceGroupName", newJString(resourceGroupName))
  add(query_594039, "api-version", newJString(apiVersion))
  add(query_594039, "$expand", newJString(Expand))
  add(path_594038, "subscriptionId", newJString(subscriptionId))
  add(path_594038, "resourceName", newJString(resourceName))
  add(query_594039, "$select", newJString(Select))
  add(path_594038, "resourceNamespace", newJString(resourceNamespace))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var componentsGet* = Call_ComponentsGet_594024(name: "componentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/components/{componentId}",
    validator: validate_ComponentsGet_594025, base: "", url: url_ComponentsGet_594026,
    schemes: {Scheme.Https})
type
  Call_MonitorInstancesListByResource_594040 = ref object of OpenApiRestCall_593425
proc url_MonitorInstancesListByResource_594042(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitorInstances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorInstancesListByResource_594041(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594043 = path.getOrDefault("resourceType")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "resourceType", valid_594043
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("resourceName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "resourceName", valid_594046
  var valid_594047 = path.getOrDefault("resourceNamespace")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "resourceNamespace", valid_594047
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort the result on one or more properties.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $top: JString
  ##       : Limit the result to the specified number of rows.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $apply: JString
  ##         : Apply aggregation.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  var valid_594048 = query.getOrDefault("$orderby")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "$orderby", valid_594048
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594049 = query.getOrDefault("api-version")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594049 != nil:
    section.add "api-version", valid_594049
  var valid_594050 = query.getOrDefault("$expand")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "$expand", valid_594050
  var valid_594051 = query.getOrDefault("$top")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "$top", valid_594051
  var valid_594052 = query.getOrDefault("$select")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "$select", valid_594052
  var valid_594053 = query.getOrDefault("$skiptoken")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "$skiptoken", valid_594053
  var valid_594054 = query.getOrDefault("$apply")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "$apply", valid_594054
  var valid_594055 = query.getOrDefault("$filter")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "$filter", valid_594055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_MonitorInstancesListByResource_594040; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_MonitorInstancesListByResource_594040;
          resourceType: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string; Orderby: string = "";
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Top: string = ""; Select: string = ""; Skiptoken: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## monitorInstancesListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   Orderby: string
  ##          : Sort the result on one or more properties.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: string
  ##      : Limit the result to the specified number of rows.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Apply: string
  ##        : Apply aggregation.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  add(path_594058, "resourceType", newJString(resourceType))
  add(query_594059, "$orderby", newJString(Orderby))
  add(path_594058, "resourceGroupName", newJString(resourceGroupName))
  add(query_594059, "api-version", newJString(apiVersion))
  add(query_594059, "$expand", newJString(Expand))
  add(path_594058, "subscriptionId", newJString(subscriptionId))
  add(query_594059, "$top", newJString(Top))
  add(path_594058, "resourceName", newJString(resourceName))
  add(query_594059, "$select", newJString(Select))
  add(path_594058, "resourceNamespace", newJString(resourceNamespace))
  add(query_594059, "$skiptoken", newJString(Skiptoken))
  add(query_594059, "$apply", newJString(Apply))
  add(query_594059, "$filter", newJString(Filter))
  result = call_594057.call(path_594058, query_594059, nil, nil, nil)

var monitorInstancesListByResource* = Call_MonitorInstancesListByResource_594040(
    name: "monitorInstancesListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitorInstances",
    validator: validate_MonitorInstancesListByResource_594041, base: "",
    url: url_MonitorInstancesListByResource_594042, schemes: {Scheme.Https})
type
  Call_MonitorInstancesGet_594060 = ref object of OpenApiRestCall_593425
proc url_MonitorInstancesGet_594062(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "monitorInstanceId" in path,
        "`monitorInstanceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitorInstances/"),
               (kind: VariableSegment, value: "monitorInstanceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorInstancesGet_594061(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   monitorInstanceId: JString (required)
  ##                    : MonitorInstance Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594063 = path.getOrDefault("resourceType")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceType", valid_594063
  var valid_594064 = path.getOrDefault("resourceGroupName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "resourceGroupName", valid_594064
  var valid_594065 = path.getOrDefault("subscriptionId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "subscriptionId", valid_594065
  var valid_594066 = path.getOrDefault("resourceName")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "resourceName", valid_594066
  var valid_594067 = path.getOrDefault("resourceNamespace")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceNamespace", valid_594067
  var valid_594068 = path.getOrDefault("monitorInstanceId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "monitorInstanceId", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $expand: JString
  ##          : Include properties inline in the response.
  ##   $select: JString
  ##          : Properties to be returned in the response.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594069 != nil:
    section.add "api-version", valid_594069
  var valid_594070 = query.getOrDefault("$expand")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "$expand", valid_594070
  var valid_594071 = query.getOrDefault("$select")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "$select", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594072: Call_MonitorInstancesGet_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594072.validator(path, query, header, formData, body)
  let scheme = call_594072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594072.url(scheme.get, call_594072.host, call_594072.base,
                         call_594072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594072, url, valid)

proc call*(call_594073: Call_MonitorInstancesGet_594060; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; monitorInstanceId: string;
          apiVersion: string = "2018-08-31-preview"; Expand: string = "";
          Select: string = ""): Recallable =
  ## monitorInstancesGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   Expand: string
  ##         : Include properties inline in the response.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   Select: string
  ##         : Properties to be returned in the response.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   monitorInstanceId: string (required)
  ##                    : MonitorInstance Id.
  var path_594074 = newJObject()
  var query_594075 = newJObject()
  add(path_594074, "resourceType", newJString(resourceType))
  add(path_594074, "resourceGroupName", newJString(resourceGroupName))
  add(query_594075, "api-version", newJString(apiVersion))
  add(query_594075, "$expand", newJString(Expand))
  add(path_594074, "subscriptionId", newJString(subscriptionId))
  add(path_594074, "resourceName", newJString(resourceName))
  add(query_594075, "$select", newJString(Select))
  add(path_594074, "resourceNamespace", newJString(resourceNamespace))
  add(path_594074, "monitorInstanceId", newJString(monitorInstanceId))
  result = call_594073.call(path_594074, query_594075, nil, nil, nil)

var monitorInstancesGet* = Call_MonitorInstancesGet_594060(
    name: "monitorInstancesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitorInstances/{monitorInstanceId}",
    validator: validate_MonitorInstancesGet_594061, base: "",
    url: url_MonitorInstancesGet_594062, schemes: {Scheme.Https})
type
  Call_MonitorsListByResource_594076 = ref object of OpenApiRestCall_593425
proc url_MonitorsListByResource_594078(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorsListByResource_594077(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594079 = path.getOrDefault("resourceType")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceType", valid_594079
  var valid_594080 = path.getOrDefault("resourceGroupName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "resourceGroupName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("resourceName")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "resourceName", valid_594082
  var valid_594083 = path.getOrDefault("resourceNamespace")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "resourceNamespace", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  ##   $filter: JString
  ##          : Filter to be applied on the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594084 != nil:
    section.add "api-version", valid_594084
  var valid_594085 = query.getOrDefault("$skiptoken")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "$skiptoken", valid_594085
  var valid_594086 = query.getOrDefault("$filter")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "$filter", valid_594086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594087: Call_MonitorsListByResource_594076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594087.validator(path, query, header, formData, body)
  let scheme = call_594087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594087.url(scheme.get, call_594087.host, call_594087.base,
                         call_594087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594087, url, valid)

proc call*(call_594088: Call_MonitorsListByResource_594076; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; apiVersion: string = "2018-08-31-preview";
          Skiptoken: string = ""; Filter: string = ""): Recallable =
  ## monitorsListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  ##   Filter: string
  ##         : Filter to be applied on the operation.
  var path_594089 = newJObject()
  var query_594090 = newJObject()
  add(path_594089, "resourceType", newJString(resourceType))
  add(path_594089, "resourceGroupName", newJString(resourceGroupName))
  add(query_594090, "api-version", newJString(apiVersion))
  add(path_594089, "subscriptionId", newJString(subscriptionId))
  add(path_594089, "resourceName", newJString(resourceName))
  add(path_594089, "resourceNamespace", newJString(resourceNamespace))
  add(query_594090, "$skiptoken", newJString(Skiptoken))
  add(query_594090, "$filter", newJString(Filter))
  result = call_594088.call(path_594089, query_594090, nil, nil, nil)

var monitorsListByResource* = Call_MonitorsListByResource_594076(
    name: "monitorsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors",
    validator: validate_MonitorsListByResource_594077, base: "",
    url: url_MonitorsListByResource_594078, schemes: {Scheme.Https})
type
  Call_MonitorsGet_594091 = ref object of OpenApiRestCall_593425
proc url_MonitorsGet_594093(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "monitorId" in path, "`monitorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitors/"),
               (kind: VariableSegment, value: "monitorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorsGet_594092(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: JString (required)
  ##            : Monitor Id.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594094 = path.getOrDefault("resourceType")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceType", valid_594094
  var valid_594095 = path.getOrDefault("resourceGroupName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "resourceGroupName", valid_594095
  var valid_594096 = path.getOrDefault("monitorId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "monitorId", valid_594096
  var valid_594097 = path.getOrDefault("subscriptionId")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "subscriptionId", valid_594097
  var valid_594098 = path.getOrDefault("resourceName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "resourceName", valid_594098
  var valid_594099 = path.getOrDefault("resourceNamespace")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "resourceNamespace", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_MonitorsGet_594091; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_MonitorsGet_594091; resourceType: string;
          resourceGroupName: string; monitorId: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string;
          apiVersion: string = "2018-08-31-preview"): Recallable =
  ## monitorsGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: string (required)
  ##            : Monitor Id.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "resourceType", newJString(resourceType))
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(path_594103, "monitorId", newJString(monitorId))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(path_594103, "resourceName", newJString(resourceName))
  add(path_594103, "resourceNamespace", newJString(resourceNamespace))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var monitorsGet* = Call_MonitorsGet_594091(name: "monitorsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors/{monitorId}",
                                        validator: validate_MonitorsGet_594092,
                                        base: "", url: url_MonitorsGet_594093,
                                        schemes: {Scheme.Https})
type
  Call_MonitorsUpdate_594105 = ref object of OpenApiRestCall_593425
proc url_MonitorsUpdate_594107(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "monitorId" in path, "`monitorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/monitors/"),
               (kind: VariableSegment, value: "monitorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_MonitorsUpdate_594106(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: JString (required)
  ##            : Monitor Id.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594108 = path.getOrDefault("resourceType")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceType", valid_594108
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("monitorId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "monitorId", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  var valid_594112 = path.getOrDefault("resourceName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "resourceName", valid_594112
  var valid_594113 = path.getOrDefault("resourceNamespace")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceNamespace", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594114 = query.getOrDefault("api-version")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594114 != nil:
    section.add "api-version", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body of the Monitor PATCH object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_MonitorsUpdate_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_MonitorsUpdate_594105; resourceType: string;
          resourceGroupName: string; monitorId: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string; body: JsonNode;
          apiVersion: string = "2018-08-31-preview"): Recallable =
  ## monitorsUpdate
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   monitorId: string (required)
  ##            : Monitor Id.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   body: JObject (required)
  ##       : Body of the Monitor PATCH object.
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(path_594118, "resourceType", newJString(resourceType))
  add(path_594118, "resourceGroupName", newJString(resourceGroupName))
  add(path_594118, "monitorId", newJString(monitorId))
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "subscriptionId", newJString(subscriptionId))
  add(path_594118, "resourceName", newJString(resourceName))
  add(path_594118, "resourceNamespace", newJString(resourceNamespace))
  if body != nil:
    body_594120 = body
  result = call_594117.call(path_594118, query_594119, nil, nil, body_594120)

var monitorsUpdate* = Call_MonitorsUpdate_594105(name: "monitorsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/monitors/{monitorId}",
    validator: validate_MonitorsUpdate_594106, base: "", url: url_MonitorsUpdate_594107,
    schemes: {Scheme.Https})
type
  Call_NotificationSettingsListByResource_594121 = ref object of OpenApiRestCall_593425
proc url_NotificationSettingsListByResource_594123(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/notificationSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationSettingsListByResource_594122(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594124 = path.getOrDefault("resourceType")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceType", valid_594124
  var valid_594125 = path.getOrDefault("resourceGroupName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "resourceGroupName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("resourceName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "resourceName", valid_594127
  var valid_594128 = path.getOrDefault("resourceNamespace")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "resourceNamespace", valid_594128
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $skiptoken: JString
  ##             : The page-continuation token to use with a paged version of this API.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  var valid_594130 = query.getOrDefault("$skiptoken")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "$skiptoken", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_NotificationSettingsListByResource_594121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_NotificationSettingsListByResource_594121;
          resourceType: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string;
          apiVersion: string = "2018-08-31-preview"; Skiptoken: string = ""): Recallable =
  ## notificationSettingsListByResource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   Skiptoken: string
  ##            : The page-continuation token to use with a paged version of this API.
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "resourceType", newJString(resourceType))
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "resourceName", newJString(resourceName))
  add(path_594133, "resourceNamespace", newJString(resourceNamespace))
  add(query_594134, "$skiptoken", newJString(Skiptoken))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var notificationSettingsListByResource* = Call_NotificationSettingsListByResource_594121(
    name: "notificationSettingsListByResource", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings",
    validator: validate_NotificationSettingsListByResource_594122, base: "",
    url: url_NotificationSettingsListByResource_594123, schemes: {Scheme.Https})
type
  Call_NotificationSettingsUpdate_594149 = ref object of OpenApiRestCall_593425
proc url_NotificationSettingsUpdate_594151(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "notificationSettingName" in path,
        "`notificationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/notificationSettings/"),
               (kind: VariableSegment, value: "notificationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationSettingsUpdate_594150(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   notificationSettingName: JString (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594152 = path.getOrDefault("resourceType")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "resourceType", valid_594152
  var valid_594153 = path.getOrDefault("resourceGroupName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "resourceGroupName", valid_594153
  var valid_594154 = path.getOrDefault("subscriptionId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscriptionId", valid_594154
  var valid_594155 = path.getOrDefault("resourceName")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "resourceName", valid_594155
  var valid_594156 = path.getOrDefault("resourceNamespace")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "resourceNamespace", valid_594156
  var valid_594157 = path.getOrDefault("notificationSettingName")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = newJString("default"))
  if valid_594157 != nil:
    section.add "notificationSettingName", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Body of the NotificationSetting PUT object.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594160: Call_NotificationSettingsUpdate_594149; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594160.validator(path, query, header, formData, body)
  let scheme = call_594160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594160.url(scheme.get, call_594160.host, call_594160.base,
                         call_594160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594160, url, valid)

proc call*(call_594161: Call_NotificationSettingsUpdate_594149;
          resourceType: string; resourceGroupName: string; subscriptionId: string;
          resourceName: string; resourceNamespace: string; body: JsonNode;
          apiVersion: string = "2018-08-31-preview";
          notificationSettingName: string = "default"): Recallable =
  ## notificationSettingsUpdate
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   body: JObject (required)
  ##       : Body of the NotificationSetting PUT object.
  ##   notificationSettingName: string (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  var path_594162 = newJObject()
  var query_594163 = newJObject()
  var body_594164 = newJObject()
  add(path_594162, "resourceType", newJString(resourceType))
  add(path_594162, "resourceGroupName", newJString(resourceGroupName))
  add(query_594163, "api-version", newJString(apiVersion))
  add(path_594162, "subscriptionId", newJString(subscriptionId))
  add(path_594162, "resourceName", newJString(resourceName))
  add(path_594162, "resourceNamespace", newJString(resourceNamespace))
  if body != nil:
    body_594164 = body
  add(path_594162, "notificationSettingName", newJString(notificationSettingName))
  result = call_594161.call(path_594162, query_594163, nil, nil, body_594164)

var notificationSettingsUpdate* = Call_NotificationSettingsUpdate_594149(
    name: "notificationSettingsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings/{notificationSettingName}",
    validator: validate_NotificationSettingsUpdate_594150, base: "",
    url: url_NotificationSettingsUpdate_594151, schemes: {Scheme.Https})
type
  Call_NotificationSettingsGet_594135 = ref object of OpenApiRestCall_593425
proc url_NotificationSettingsGet_594137(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "notificationSettingName" in path,
        "`notificationSettingName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.WorkloadMonitor/notificationSettings/"),
               (kind: VariableSegment, value: "notificationSettingName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NotificationSettingsGet_594136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   notificationSettingName: JString (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_594138 = path.getOrDefault("resourceType")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceType", valid_594138
  var valid_594139 = path.getOrDefault("resourceGroupName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "resourceGroupName", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("resourceName")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = nil)
  if valid_594141 != nil:
    section.add "resourceName", valid_594141
  var valid_594142 = path.getOrDefault("resourceNamespace")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "resourceNamespace", valid_594142
  var valid_594143 = path.getOrDefault("notificationSettingName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = newJString("default"))
  if valid_594143 != nil:
    section.add "notificationSettingName", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = newJString("2018-08-31-preview"))
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_NotificationSettingsGet_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_NotificationSettingsGet_594135; resourceType: string;
          resourceGroupName: string; subscriptionId: string; resourceName: string;
          resourceNamespace: string; apiVersion: string = "2018-08-31-preview";
          notificationSettingName: string = "default"): Recallable =
  ## notificationSettingsGet
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   notificationSettingName: string (required)
  ##                          : Default string modeled as parameter for URL to work correctly.
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  add(path_594147, "resourceType", newJString(resourceType))
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  add(path_594147, "resourceName", newJString(resourceName))
  add(path_594147, "resourceNamespace", newJString(resourceNamespace))
  add(path_594147, "notificationSettingName", newJString(notificationSettingName))
  result = call_594146.call(path_594147, query_594148, nil, nil, nil)

var notificationSettingsGet* = Call_NotificationSettingsGet_594135(
    name: "notificationSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.WorkloadMonitor/notificationSettings/{notificationSettingName}",
    validator: validate_NotificationSettingsGet_594136, base: "",
    url: url_NotificationSettingsGet_594137, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

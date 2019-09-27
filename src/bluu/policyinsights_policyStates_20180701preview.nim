
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: PolicyStatesClient
## version: 2018-07-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "policyinsights-policyStates"
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
  ## Lists available operations.
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
  var valid_593808 = query.getOrDefault("api-version")
  valid_593808 = validateParameter(valid_593808, JString, required = true,
                                 default = nil)
  if valid_593808 != nil:
    section.add "api-version", valid_593808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593831: Call_OperationsList_593647; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations.
  ## 
  let valid = call_593831.validator(path, query, header, formData, body)
  let scheme = call_593831.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593831.url(scheme.get, call_593831.host, call_593831.base,
                         call_593831.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593831, url, valid)

proc call*(call_593902: Call_OperationsList_593647; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.PolicyInsights/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForManagementGroup_593943 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForManagementGroup_593945(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForManagementGroup_593944(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_593961 = path.getOrDefault("managementGroupName")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "managementGroupName", valid_593961
  var valid_593975 = path.getOrDefault("managementGroupsNamespace")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_593975 != nil:
    section.add "managementGroupsNamespace", valid_593975
  var valid_593976 = path.getOrDefault("policyStatesResource")
  valid_593976 = validateParameter(valid_593976, JString, required = true,
                                 default = newJString("default"))
  if valid_593976 != nil:
    section.add "policyStatesResource", valid_593976
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_593977 = query.getOrDefault("$orderby")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "$orderby", valid_593977
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593978 = query.getOrDefault("api-version")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "api-version", valid_593978
  var valid_593979 = query.getOrDefault("$from")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "$from", valid_593979
  var valid_593980 = query.getOrDefault("$top")
  valid_593980 = validateParameter(valid_593980, JInt, required = false, default = nil)
  if valid_593980 != nil:
    section.add "$top", valid_593980
  var valid_593981 = query.getOrDefault("$select")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "$select", valid_593981
  var valid_593982 = query.getOrDefault("$to")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "$to", valid_593982
  var valid_593983 = query.getOrDefault("$apply")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "$apply", valid_593983
  var valid_593984 = query.getOrDefault("$filter")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "$filter", valid_593984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593985: Call_PolicyStatesListQueryResultsForManagementGroup_593943;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the management group.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_PolicyStatesListQueryResultsForManagementGroup_593943;
          managementGroupName: string; apiVersion: string;
          managementGroupsNamespace: string = "Microsoft.Management";
          Orderby: string = ""; From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForManagementGroup
  ## Queries policy states for the resources under the management group.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_593987 = newJObject()
  var query_593988 = newJObject()
  add(path_593987, "managementGroupName", newJString(managementGroupName))
  add(path_593987, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_593988, "$orderby", newJString(Orderby))
  add(query_593988, "api-version", newJString(apiVersion))
  add(query_593988, "$from", newJString(From))
  add(query_593988, "$top", newJInt(Top))
  add(query_593988, "$select", newJString(Select))
  add(path_593987, "policyStatesResource", newJString(policyStatesResource))
  add(query_593988, "$to", newJString(To))
  add(query_593988, "$apply", newJString(Apply))
  add(query_593988, "$filter", newJString(Filter))
  result = call_593986.call(path_593987, query_593988, nil, nil, nil)

var policyStatesListQueryResultsForManagementGroup* = Call_PolicyStatesListQueryResultsForManagementGroup_593943(
    name: "policyStatesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForManagementGroup_593944,
    base: "", url: url_PolicyStatesListQueryResultsForManagementGroup_593945,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForManagementGroup_593989 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForManagementGroup_593991(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "managementGroupsNamespace" in path,
        "`managementGroupsNamespace` is a required path parameter"
  assert "managementGroupName" in path,
        "`managementGroupName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "managementGroupsNamespace"),
               (kind: ConstantSegment, value: "/managementGroups/"),
               (kind: VariableSegment, value: "managementGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForManagementGroup_593990(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resources under the management group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managementGroupName: JString (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: JString (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managementGroupName` field"
  var valid_593992 = path.getOrDefault("managementGroupName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "managementGroupName", valid_593992
  var valid_593993 = path.getOrDefault("managementGroupsNamespace")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_593993 != nil:
    section.add "managementGroupsNamespace", valid_593993
  var valid_593994 = path.getOrDefault("policyStatesSummaryResource")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("latest"))
  if valid_593994 != nil:
    section.add "policyStatesSummaryResource", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  var valid_593996 = query.getOrDefault("$from")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "$from", valid_593996
  var valid_593997 = query.getOrDefault("$top")
  valid_593997 = validateParameter(valid_593997, JInt, required = false, default = nil)
  if valid_593997 != nil:
    section.add "$top", valid_593997
  var valid_593998 = query.getOrDefault("$to")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "$to", valid_593998
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

proc call*(call_594000: Call_PolicyStatesSummarizeForManagementGroup_593989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the management group.
  ## 
  let valid = call_594000.validator(path, query, header, formData, body)
  let scheme = call_594000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594000.url(scheme.get, call_594000.host, call_594000.base,
                         call_594000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594000, url, valid)

proc call*(call_594001: Call_PolicyStatesSummarizeForManagementGroup_593989;
          managementGroupName: string; apiVersion: string;
          managementGroupsNamespace: string = "Microsoft.Management";
          policyStatesSummaryResource: string = "latest"; From: string = "";
          Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForManagementGroup
  ## Summarizes policy states for the resources under the management group.
  ##   managementGroupName: string (required)
  ##                      : Management group name.
  ##   managementGroupsNamespace: string (required)
  ##                            : The namespace for Microsoft Management RP; only "Microsoft.Management" is allowed.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594002 = newJObject()
  var query_594003 = newJObject()
  add(path_594002, "managementGroupName", newJString(managementGroupName))
  add(path_594002, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(path_594002, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_594003, "api-version", newJString(apiVersion))
  add(query_594003, "$from", newJString(From))
  add(query_594003, "$top", newJInt(Top))
  add(query_594003, "$to", newJString(To))
  add(query_594003, "$filter", newJString(Filter))
  result = call_594001.call(path_594002, query_594003, nil, nil, nil)

var policyStatesSummarizeForManagementGroup* = Call_PolicyStatesSummarizeForManagementGroup_593989(
    name: "policyStatesSummarizeForManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForManagementGroup_593990, base: "",
    url: url_PolicyStatesSummarizeForManagementGroup_593991,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscription_594004 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForSubscription_594006(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForSubscription_594005(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594007 = path.getOrDefault("subscriptionId")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "subscriptionId", valid_594007
  var valid_594008 = path.getOrDefault("policyStatesResource")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = newJString("default"))
  if valid_594008 != nil:
    section.add "policyStatesResource", valid_594008
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594009 = query.getOrDefault("$orderby")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "$orderby", valid_594009
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  var valid_594011 = query.getOrDefault("$from")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "$from", valid_594011
  var valid_594012 = query.getOrDefault("$top")
  valid_594012 = validateParameter(valid_594012, JInt, required = false, default = nil)
  if valid_594012 != nil:
    section.add "$top", valid_594012
  var valid_594013 = query.getOrDefault("$select")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "$select", valid_594013
  var valid_594014 = query.getOrDefault("$to")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "$to", valid_594014
  var valid_594015 = query.getOrDefault("$apply")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "$apply", valid_594015
  var valid_594016 = query.getOrDefault("$filter")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "$filter", valid_594016
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594017: Call_PolicyStatesListQueryResultsForSubscription_594004;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the subscription.
  ## 
  let valid = call_594017.validator(path, query, header, formData, body)
  let scheme = call_594017.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594017.url(scheme.get, call_594017.host, call_594017.base,
                         call_594017.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594017, url, valid)

proc call*(call_594018: Call_PolicyStatesListQueryResultsForSubscription_594004;
          apiVersion: string; subscriptionId: string; Orderby: string = "";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForSubscription
  ## Queries policy states for the resources under the subscription.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594019 = newJObject()
  var query_594020 = newJObject()
  add(query_594020, "$orderby", newJString(Orderby))
  add(query_594020, "api-version", newJString(apiVersion))
  add(query_594020, "$from", newJString(From))
  add(path_594019, "subscriptionId", newJString(subscriptionId))
  add(query_594020, "$top", newJInt(Top))
  add(query_594020, "$select", newJString(Select))
  add(path_594019, "policyStatesResource", newJString(policyStatesResource))
  add(query_594020, "$to", newJString(To))
  add(query_594020, "$apply", newJString(Apply))
  add(query_594020, "$filter", newJString(Filter))
  result = call_594018.call(path_594019, query_594020, nil, nil, nil)

var policyStatesListQueryResultsForSubscription* = Call_PolicyStatesListQueryResultsForSubscription_594004(
    name: "policyStatesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForSubscription_594005,
    base: "", url: url_PolicyStatesListQueryResultsForSubscription_594006,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForSubscription_594021 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForSubscription_594023(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForSubscription_594022(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resources under the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesSummaryResource` field"
  var valid_594024 = path.getOrDefault("policyStatesSummaryResource")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = newJString("latest"))
  if valid_594024 != nil:
    section.add "policyStatesSummaryResource", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  var valid_594027 = query.getOrDefault("$from")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "$from", valid_594027
  var valid_594028 = query.getOrDefault("$top")
  valid_594028 = validateParameter(valid_594028, JInt, required = false, default = nil)
  if valid_594028 != nil:
    section.add "$top", valid_594028
  var valid_594029 = query.getOrDefault("$to")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "$to", valid_594029
  var valid_594030 = query.getOrDefault("$filter")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "$filter", valid_594030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594031: Call_PolicyStatesSummarizeForSubscription_594021;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the subscription.
  ## 
  let valid = call_594031.validator(path, query, header, formData, body)
  let scheme = call_594031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594031.url(scheme.get, call_594031.host, call_594031.base,
                         call_594031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594031, url, valid)

proc call*(call_594032: Call_PolicyStatesSummarizeForSubscription_594021;
          apiVersion: string; subscriptionId: string;
          policyStatesSummaryResource: string = "latest"; From: string = "";
          Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForSubscription
  ## Summarizes policy states for the resources under the subscription.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594033 = newJObject()
  var query_594034 = newJObject()
  add(path_594033, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_594034, "api-version", newJString(apiVersion))
  add(query_594034, "$from", newJString(From))
  add(path_594033, "subscriptionId", newJString(subscriptionId))
  add(query_594034, "$top", newJInt(Top))
  add(query_594034, "$to", newJString(To))
  add(query_594034, "$filter", newJString(Filter))
  result = call_594032.call(path_594033, query_594034, nil, nil, nil)

var policyStatesSummarizeForSubscription* = Call_PolicyStatesSummarizeForSubscription_594021(
    name: "policyStatesSummarizeForSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForSubscription_594022, base: "",
    url: url_PolicyStatesSummarizeForSubscription_594023, schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594035 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594037(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594036(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the subscription level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_594038 = path.getOrDefault("authorizationNamespace")
  valid_594038 = validateParameter(valid_594038, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594038 != nil:
    section.add "authorizationNamespace", valid_594038
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
  var valid_594040 = path.getOrDefault("policyAssignmentName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "policyAssignmentName", valid_594040
  var valid_594041 = path.getOrDefault("policyStatesResource")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = newJString("default"))
  if valid_594041 != nil:
    section.add "policyStatesResource", valid_594041
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594042 = query.getOrDefault("$orderby")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "$orderby", valid_594042
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594043 = query.getOrDefault("api-version")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "api-version", valid_594043
  var valid_594044 = query.getOrDefault("$from")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "$from", valid_594044
  var valid_594045 = query.getOrDefault("$top")
  valid_594045 = validateParameter(valid_594045, JInt, required = false, default = nil)
  if valid_594045 != nil:
    section.add "$top", valid_594045
  var valid_594046 = query.getOrDefault("$select")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "$select", valid_594046
  var valid_594047 = query.getOrDefault("$to")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "$to", valid_594047
  var valid_594048 = query.getOrDefault("$apply")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "$apply", valid_594048
  var valid_594049 = query.getOrDefault("$filter")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "$filter", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy assignment.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594035;
          apiVersion: string; subscriptionId: string; policyAssignmentName: string;
          Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment
  ## Queries policy states for the subscription level policy assignment.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(query_594053, "$orderby", newJString(Orderby))
  add(path_594052, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594053, "api-version", newJString(apiVersion))
  add(query_594053, "$from", newJString(From))
  add(path_594052, "subscriptionId", newJString(subscriptionId))
  add(query_594053, "$top", newJInt(Top))
  add(query_594053, "$select", newJString(Select))
  add(path_594052, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_594052, "policyStatesResource", newJString(policyStatesResource))
  add(query_594053, "$to", newJString(To))
  add(query_594053, "$apply", newJString(Apply))
  add(query_594053, "$filter", newJString(Filter))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment* = Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594035(
    name: "policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults", validator: validate_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594036,
    base: "",
    url: url_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_594037,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594054 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594056(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Summarizes policy states for the subscription level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesSummaryResource` field"
  var valid_594057 = path.getOrDefault("policyStatesSummaryResource")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = newJString("latest"))
  if valid_594057 != nil:
    section.add "policyStatesSummaryResource", valid_594057
  var valid_594058 = path.getOrDefault("authorizationNamespace")
  valid_594058 = validateParameter(valid_594058, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594058 != nil:
    section.add "authorizationNamespace", valid_594058
  var valid_594059 = path.getOrDefault("subscriptionId")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "subscriptionId", valid_594059
  var valid_594060 = path.getOrDefault("policyAssignmentName")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "policyAssignmentName", valid_594060
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594061 = query.getOrDefault("api-version")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "api-version", valid_594061
  var valid_594062 = query.getOrDefault("$from")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "$from", valid_594062
  var valid_594063 = query.getOrDefault("$top")
  valid_594063 = validateParameter(valid_594063, JInt, required = false, default = nil)
  if valid_594063 != nil:
    section.add "$top", valid_594063
  var valid_594064 = query.getOrDefault("$to")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "$to", valid_594064
  var valid_594065 = query.getOrDefault("$filter")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "$filter", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy assignment.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594054;
          apiVersion: string; subscriptionId: string; policyAssignmentName: string;
          policyStatesSummaryResource: string = "latest";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForSubscriptionLevelPolicyAssignment
  ## Summarizes policy states for the subscription level policy assignment.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_594068, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594069, "api-version", newJString(apiVersion))
  add(query_594069, "$from", newJString(From))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(query_594069, "$top", newJInt(Top))
  add(path_594068, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_594069, "$to", newJString(To))
  add(query_594069, "$filter", newJString(Filter))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var policyStatesSummarizeForSubscriptionLevelPolicyAssignment* = Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594054(
    name: "policyStatesSummarizeForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize", validator: validate_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594055,
    base: "", url: url_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_594056,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForPolicyDefinition_594070 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForPolicyDefinition_594072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForPolicyDefinition_594071(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the subscription level policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   policyDefinitionName: JString (required)
  ##                       : Policy definition name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `authorizationNamespace` field"
  var valid_594073 = path.getOrDefault("authorizationNamespace")
  valid_594073 = validateParameter(valid_594073, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594073 != nil:
    section.add "authorizationNamespace", valid_594073
  var valid_594074 = path.getOrDefault("subscriptionId")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "subscriptionId", valid_594074
  var valid_594075 = path.getOrDefault("policyStatesResource")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = newJString("default"))
  if valid_594075 != nil:
    section.add "policyStatesResource", valid_594075
  var valid_594076 = path.getOrDefault("policyDefinitionName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "policyDefinitionName", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594077 = query.getOrDefault("$orderby")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "$orderby", valid_594077
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594078 = query.getOrDefault("api-version")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "api-version", valid_594078
  var valid_594079 = query.getOrDefault("$from")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "$from", valid_594079
  var valid_594080 = query.getOrDefault("$top")
  valid_594080 = validateParameter(valid_594080, JInt, required = false, default = nil)
  if valid_594080 != nil:
    section.add "$top", valid_594080
  var valid_594081 = query.getOrDefault("$select")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "$select", valid_594081
  var valid_594082 = query.getOrDefault("$to")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "$to", valid_594082
  var valid_594083 = query.getOrDefault("$apply")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "$apply", valid_594083
  var valid_594084 = query.getOrDefault("$filter")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "$filter", valid_594084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594085: Call_PolicyStatesListQueryResultsForPolicyDefinition_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy definition.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_PolicyStatesListQueryResultsForPolicyDefinition_594070;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForPolicyDefinition
  ## Queries policy states for the subscription level policy definition.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   policyDefinitionName: string (required)
  ##                       : Policy definition name.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  add(query_594088, "$orderby", newJString(Orderby))
  add(path_594087, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594088, "api-version", newJString(apiVersion))
  add(query_594088, "$from", newJString(From))
  add(path_594087, "subscriptionId", newJString(subscriptionId))
  add(query_594088, "$top", newJInt(Top))
  add(query_594088, "$select", newJString(Select))
  add(path_594087, "policyStatesResource", newJString(policyStatesResource))
  add(query_594088, "$to", newJString(To))
  add(query_594088, "$apply", newJString(Apply))
  add(path_594087, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_594088, "$filter", newJString(Filter))
  result = call_594086.call(path_594087, query_594088, nil, nil, nil)

var policyStatesListQueryResultsForPolicyDefinition* = Call_PolicyStatesListQueryResultsForPolicyDefinition_594070(
    name: "policyStatesListQueryResultsForPolicyDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForPolicyDefinition_594071,
    base: "", url: url_PolicyStatesListQueryResultsForPolicyDefinition_594072,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForPolicyDefinition_594089 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForPolicyDefinition_594091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyDefinitionName" in path,
        "`policyDefinitionName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyDefinitions/"),
               (kind: VariableSegment, value: "policyDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForPolicyDefinition_594090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the subscription level policy definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyDefinitionName: JString (required)
  ##                       : Policy definition name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesSummaryResource` field"
  var valid_594092 = path.getOrDefault("policyStatesSummaryResource")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = newJString("latest"))
  if valid_594092 != nil:
    section.add "policyStatesSummaryResource", valid_594092
  var valid_594093 = path.getOrDefault("authorizationNamespace")
  valid_594093 = validateParameter(valid_594093, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594093 != nil:
    section.add "authorizationNamespace", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("policyDefinitionName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "policyDefinitionName", valid_594095
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594096 = query.getOrDefault("api-version")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "api-version", valid_594096
  var valid_594097 = query.getOrDefault("$from")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "$from", valid_594097
  var valid_594098 = query.getOrDefault("$top")
  valid_594098 = validateParameter(valid_594098, JInt, required = false, default = nil)
  if valid_594098 != nil:
    section.add "$top", valid_594098
  var valid_594099 = query.getOrDefault("$to")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "$to", valid_594099
  var valid_594100 = query.getOrDefault("$filter")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "$filter", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_PolicyStatesSummarizeForPolicyDefinition_594089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy definition.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_PolicyStatesSummarizeForPolicyDefinition_594089;
          apiVersion: string; subscriptionId: string; policyDefinitionName: string;
          policyStatesSummaryResource: string = "latest";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForPolicyDefinition
  ## Summarizes policy states for the subscription level policy definition.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   policyDefinitionName: string (required)
  ##                       : Policy definition name.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_594103, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594104, "api-version", newJString(apiVersion))
  add(query_594104, "$from", newJString(From))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(query_594104, "$top", newJInt(Top))
  add(query_594104, "$to", newJString(To))
  add(path_594103, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_594104, "$filter", newJString(Filter))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var policyStatesSummarizeForPolicyDefinition* = Call_PolicyStatesSummarizeForPolicyDefinition_594089(
    name: "policyStatesSummarizeForPolicyDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForPolicyDefinition_594090, base: "",
    url: url_PolicyStatesSummarizeForPolicyDefinition_594091,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForPolicySetDefinition_594105 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForPolicySetDefinition_594107(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForPolicySetDefinition_594106(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the subscription level policy set definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : Policy set definition name.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_594108 = path.getOrDefault("policySetDefinitionName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "policySetDefinitionName", valid_594108
  var valid_594109 = path.getOrDefault("authorizationNamespace")
  valid_594109 = validateParameter(valid_594109, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594109 != nil:
    section.add "authorizationNamespace", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("policyStatesResource")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = newJString("default"))
  if valid_594111 != nil:
    section.add "policyStatesResource", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594112 = query.getOrDefault("$orderby")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "$orderby", valid_594112
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  var valid_594114 = query.getOrDefault("$from")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "$from", valid_594114
  var valid_594115 = query.getOrDefault("$top")
  valid_594115 = validateParameter(valid_594115, JInt, required = false, default = nil)
  if valid_594115 != nil:
    section.add "$top", valid_594115
  var valid_594116 = query.getOrDefault("$select")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "$select", valid_594116
  var valid_594117 = query.getOrDefault("$to")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "$to", valid_594117
  var valid_594118 = query.getOrDefault("$apply")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "$apply", valid_594118
  var valid_594119 = query.getOrDefault("$filter")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "$filter", valid_594119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594120: Call_PolicyStatesListQueryResultsForPolicySetDefinition_594105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy set definition.
  ## 
  let valid = call_594120.validator(path, query, header, formData, body)
  let scheme = call_594120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594120.url(scheme.get, call_594120.host, call_594120.base,
                         call_594120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594120, url, valid)

proc call*(call_594121: Call_PolicyStatesListQueryResultsForPolicySetDefinition_594105;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string; Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForPolicySetDefinition
  ## Queries policy states for the subscription level policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : Policy set definition name.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594122 = newJObject()
  var query_594123 = newJObject()
  add(path_594122, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_594123, "$orderby", newJString(Orderby))
  add(path_594122, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594123, "api-version", newJString(apiVersion))
  add(query_594123, "$from", newJString(From))
  add(path_594122, "subscriptionId", newJString(subscriptionId))
  add(query_594123, "$top", newJInt(Top))
  add(query_594123, "$select", newJString(Select))
  add(path_594122, "policyStatesResource", newJString(policyStatesResource))
  add(query_594123, "$to", newJString(To))
  add(query_594123, "$apply", newJString(Apply))
  add(query_594123, "$filter", newJString(Filter))
  result = call_594121.call(path_594122, query_594123, nil, nil, nil)

var policyStatesListQueryResultsForPolicySetDefinition* = Call_PolicyStatesListQueryResultsForPolicySetDefinition_594105(
    name: "policyStatesListQueryResultsForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForPolicySetDefinition_594106,
    base: "", url: url_PolicyStatesListQueryResultsForPolicySetDefinition_594107,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForPolicySetDefinition_594124 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForPolicySetDefinition_594126(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policySetDefinitionName" in path,
        "`policySetDefinitionName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policySetDefinitions/"),
               (kind: VariableSegment, value: "policySetDefinitionName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForPolicySetDefinition_594125(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the subscription level policy set definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policySetDefinitionName: JString (required)
  ##                          : Policy set definition name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policySetDefinitionName` field"
  var valid_594127 = path.getOrDefault("policySetDefinitionName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "policySetDefinitionName", valid_594127
  var valid_594128 = path.getOrDefault("policyStatesSummaryResource")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = newJString("latest"))
  if valid_594128 != nil:
    section.add "policyStatesSummaryResource", valid_594128
  var valid_594129 = path.getOrDefault("authorizationNamespace")
  valid_594129 = validateParameter(valid_594129, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594129 != nil:
    section.add "authorizationNamespace", valid_594129
  var valid_594130 = path.getOrDefault("subscriptionId")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "subscriptionId", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
  var valid_594132 = query.getOrDefault("$from")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "$from", valid_594132
  var valid_594133 = query.getOrDefault("$top")
  valid_594133 = validateParameter(valid_594133, JInt, required = false, default = nil)
  if valid_594133 != nil:
    section.add "$top", valid_594133
  var valid_594134 = query.getOrDefault("$to")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "$to", valid_594134
  var valid_594135 = query.getOrDefault("$filter")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "$filter", valid_594135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594136: Call_PolicyStatesSummarizeForPolicySetDefinition_594124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy set definition.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_PolicyStatesSummarizeForPolicySetDefinition_594124;
          policySetDefinitionName: string; apiVersion: string;
          subscriptionId: string; policyStatesSummaryResource: string = "latest";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForPolicySetDefinition
  ## Summarizes policy states for the subscription level policy set definition.
  ##   policySetDefinitionName: string (required)
  ##                          : Policy set definition name.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  add(path_594138, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(path_594138, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_594138, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594139, "api-version", newJString(apiVersion))
  add(query_594139, "$from", newJString(From))
  add(path_594138, "subscriptionId", newJString(subscriptionId))
  add(query_594139, "$top", newJInt(Top))
  add(query_594139, "$to", newJString(To))
  add(query_594139, "$filter", newJString(Filter))
  result = call_594137.call(path_594138, query_594139, nil, nil, nil)

var policyStatesSummarizeForPolicySetDefinition* = Call_PolicyStatesSummarizeForPolicySetDefinition_594124(
    name: "policyStatesSummarizeForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForPolicySetDefinition_594125,
    base: "", url: url_PolicyStatesSummarizeForPolicySetDefinition_594126,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroup_594140 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForResourceGroup_594142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForResourceGroup_594141(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594143 = path.getOrDefault("resourceGroupName")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "resourceGroupName", valid_594143
  var valid_594144 = path.getOrDefault("subscriptionId")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "subscriptionId", valid_594144
  var valid_594145 = path.getOrDefault("policyStatesResource")
  valid_594145 = validateParameter(valid_594145, JString, required = true,
                                 default = newJString("default"))
  if valid_594145 != nil:
    section.add "policyStatesResource", valid_594145
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594146 = query.getOrDefault("$orderby")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "$orderby", valid_594146
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594147 = query.getOrDefault("api-version")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "api-version", valid_594147
  var valid_594148 = query.getOrDefault("$from")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "$from", valid_594148
  var valid_594149 = query.getOrDefault("$top")
  valid_594149 = validateParameter(valid_594149, JInt, required = false, default = nil)
  if valid_594149 != nil:
    section.add "$top", valid_594149
  var valid_594150 = query.getOrDefault("$select")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "$select", valid_594150
  var valid_594151 = query.getOrDefault("$to")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "$to", valid_594151
  var valid_594152 = query.getOrDefault("$apply")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "$apply", valid_594152
  var valid_594153 = query.getOrDefault("$filter")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "$filter", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594154: Call_PolicyStatesListQueryResultsForResourceGroup_594140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the resource group.
  ## 
  let valid = call_594154.validator(path, query, header, formData, body)
  let scheme = call_594154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594154.url(scheme.get, call_594154.host, call_594154.base,
                         call_594154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594154, url, valid)

proc call*(call_594155: Call_PolicyStatesListQueryResultsForResourceGroup_594140;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Orderby: string = ""; From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForResourceGroup
  ## Queries policy states for the resources under the resource group.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594156 = newJObject()
  var query_594157 = newJObject()
  add(query_594157, "$orderby", newJString(Orderby))
  add(path_594156, "resourceGroupName", newJString(resourceGroupName))
  add(query_594157, "api-version", newJString(apiVersion))
  add(query_594157, "$from", newJString(From))
  add(path_594156, "subscriptionId", newJString(subscriptionId))
  add(query_594157, "$top", newJInt(Top))
  add(query_594157, "$select", newJString(Select))
  add(path_594156, "policyStatesResource", newJString(policyStatesResource))
  add(query_594157, "$to", newJString(To))
  add(query_594157, "$apply", newJString(Apply))
  add(query_594157, "$filter", newJString(Filter))
  result = call_594155.call(path_594156, query_594157, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroup* = Call_PolicyStatesListQueryResultsForResourceGroup_594140(
    name: "policyStatesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResourceGroup_594141,
    base: "", url: url_PolicyStatesListQueryResultsForResourceGroup_594142,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResourceGroup_594158 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForResourceGroup_594160(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForResourceGroup_594159(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resources under the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594161 = path.getOrDefault("resourceGroupName")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = nil)
  if valid_594161 != nil:
    section.add "resourceGroupName", valid_594161
  var valid_594162 = path.getOrDefault("policyStatesSummaryResource")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = newJString("latest"))
  if valid_594162 != nil:
    section.add "policyStatesSummaryResource", valid_594162
  var valid_594163 = path.getOrDefault("subscriptionId")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "subscriptionId", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594164 = query.getOrDefault("api-version")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "api-version", valid_594164
  var valid_594165 = query.getOrDefault("$from")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "$from", valid_594165
  var valid_594166 = query.getOrDefault("$top")
  valid_594166 = validateParameter(valid_594166, JInt, required = false, default = nil)
  if valid_594166 != nil:
    section.add "$top", valid_594166
  var valid_594167 = query.getOrDefault("$to")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "$to", valid_594167
  var valid_594168 = query.getOrDefault("$filter")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "$filter", valid_594168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594169: Call_PolicyStatesSummarizeForResourceGroup_594158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the resource group.
  ## 
  let valid = call_594169.validator(path, query, header, formData, body)
  let scheme = call_594169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594169.url(scheme.get, call_594169.host, call_594169.base,
                         call_594169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594169, url, valid)

proc call*(call_594170: Call_PolicyStatesSummarizeForResourceGroup_594158;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyStatesSummaryResource: string = "latest"; From: string = "";
          Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForResourceGroup
  ## Summarizes policy states for the resources under the resource group.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594171 = newJObject()
  var query_594172 = newJObject()
  add(path_594171, "resourceGroupName", newJString(resourceGroupName))
  add(path_594171, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_594172, "api-version", newJString(apiVersion))
  add(query_594172, "$from", newJString(From))
  add(path_594171, "subscriptionId", newJString(subscriptionId))
  add(query_594172, "$top", newJInt(Top))
  add(query_594172, "$to", newJString(To))
  add(query_594172, "$filter", newJString(Filter))
  result = call_594170.call(path_594171, query_594172, nil, nil, nil)

var policyStatesSummarizeForResourceGroup* = Call_PolicyStatesSummarizeForResourceGroup_594158(
    name: "policyStatesSummarizeForResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForResourceGroup_594159, base: "",
    url: url_PolicyStatesSummarizeForResourceGroup_594160, schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594173 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594175(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594174(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Queries policy states for the resource group level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594176 = path.getOrDefault("resourceGroupName")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "resourceGroupName", valid_594176
  var valid_594177 = path.getOrDefault("authorizationNamespace")
  valid_594177 = validateParameter(valid_594177, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594177 != nil:
    section.add "authorizationNamespace", valid_594177
  var valid_594178 = path.getOrDefault("subscriptionId")
  valid_594178 = validateParameter(valid_594178, JString, required = true,
                                 default = nil)
  if valid_594178 != nil:
    section.add "subscriptionId", valid_594178
  var valid_594179 = path.getOrDefault("policyAssignmentName")
  valid_594179 = validateParameter(valid_594179, JString, required = true,
                                 default = nil)
  if valid_594179 != nil:
    section.add "policyAssignmentName", valid_594179
  var valid_594180 = path.getOrDefault("policyStatesResource")
  valid_594180 = validateParameter(valid_594180, JString, required = true,
                                 default = newJString("default"))
  if valid_594180 != nil:
    section.add "policyStatesResource", valid_594180
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594181 = query.getOrDefault("$orderby")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "$orderby", valid_594181
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594182 = query.getOrDefault("api-version")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "api-version", valid_594182
  var valid_594183 = query.getOrDefault("$from")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "$from", valid_594183
  var valid_594184 = query.getOrDefault("$top")
  valid_594184 = validateParameter(valid_594184, JInt, required = false, default = nil)
  if valid_594184 != nil:
    section.add "$top", valid_594184
  var valid_594185 = query.getOrDefault("$select")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "$select", valid_594185
  var valid_594186 = query.getOrDefault("$to")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "$to", valid_594186
  var valid_594187 = query.getOrDefault("$apply")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "$apply", valid_594187
  var valid_594188 = query.getOrDefault("$filter")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "$filter", valid_594188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594189: Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594173;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource group level policy assignment.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594173;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyAssignmentName: string; Orderby: string = "";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment
  ## Queries policy states for the resource group level policy assignment.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594191 = newJObject()
  var query_594192 = newJObject()
  add(query_594192, "$orderby", newJString(Orderby))
  add(path_594191, "resourceGroupName", newJString(resourceGroupName))
  add(path_594191, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594192, "api-version", newJString(apiVersion))
  add(query_594192, "$from", newJString(From))
  add(path_594191, "subscriptionId", newJString(subscriptionId))
  add(query_594192, "$top", newJInt(Top))
  add(query_594192, "$select", newJString(Select))
  add(path_594191, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_594191, "policyStatesResource", newJString(policyStatesResource))
  add(query_594192, "$to", newJString(To))
  add(query_594192, "$apply", newJString(Apply))
  add(query_594192, "$filter", newJString(Filter))
  result = call_594190.call(path_594191, query_594192, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment* = Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594173(
    name: "policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults", validator: validate_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594174,
    base: "",
    url: url_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_594175,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594193 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594195(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "authorizationNamespace" in path,
        "`authorizationNamespace` is a required path parameter"
  assert "policyAssignmentName" in path,
        "`policyAssignmentName` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "authorizationNamespace"),
               (kind: ConstantSegment, value: "/policyAssignments/"),
               (kind: VariableSegment, value: "policyAssignmentName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594194(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Summarizes policy states for the resource group level policy assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Resource group name.
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: JString (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   subscriptionId: JString (required)
  ##                 : Microsoft Azure subscription ID.
  ##   policyAssignmentName: JString (required)
  ##                       : Policy assignment name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594196 = path.getOrDefault("resourceGroupName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "resourceGroupName", valid_594196
  var valid_594197 = path.getOrDefault("policyStatesSummaryResource")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = newJString("latest"))
  if valid_594197 != nil:
    section.add "policyStatesSummaryResource", valid_594197
  var valid_594198 = path.getOrDefault("authorizationNamespace")
  valid_594198 = validateParameter(valid_594198, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_594198 != nil:
    section.add "authorizationNamespace", valid_594198
  var valid_594199 = path.getOrDefault("subscriptionId")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = nil)
  if valid_594199 != nil:
    section.add "subscriptionId", valid_594199
  var valid_594200 = path.getOrDefault("policyAssignmentName")
  valid_594200 = validateParameter(valid_594200, JString, required = true,
                                 default = nil)
  if valid_594200 != nil:
    section.add "policyAssignmentName", valid_594200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594201 = query.getOrDefault("api-version")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "api-version", valid_594201
  var valid_594202 = query.getOrDefault("$from")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = nil)
  if valid_594202 != nil:
    section.add "$from", valid_594202
  var valid_594203 = query.getOrDefault("$top")
  valid_594203 = validateParameter(valid_594203, JInt, required = false, default = nil)
  if valid_594203 != nil:
    section.add "$top", valid_594203
  var valid_594204 = query.getOrDefault("$to")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "$to", valid_594204
  var valid_594205 = query.getOrDefault("$filter")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "$filter", valid_594205
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594206: Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resource group level policy assignment.
  ## 
  let valid = call_594206.validator(path, query, header, formData, body)
  let scheme = call_594206.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594206.url(scheme.get, call_594206.host, call_594206.base,
                         call_594206.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594206, url, valid)

proc call*(call_594207: Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594193;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          policyAssignmentName: string;
          policyStatesSummaryResource: string = "latest";
          authorizationNamespace: string = "Microsoft.Authorization";
          From: string = ""; Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForResourceGroupLevelPolicyAssignment
  ## Summarizes policy states for the resource group level policy assignment.
  ##   resourceGroupName: string (required)
  ##                    : Resource group name.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   authorizationNamespace: string (required)
  ##                         : The namespace for Microsoft Authorization resource provider; only "Microsoft.Authorization" is allowed.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   subscriptionId: string (required)
  ##                 : Microsoft Azure subscription ID.
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   policyAssignmentName: string (required)
  ##                       : Policy assignment name.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594208 = newJObject()
  var query_594209 = newJObject()
  add(path_594208, "resourceGroupName", newJString(resourceGroupName))
  add(path_594208, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_594208, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_594209, "api-version", newJString(apiVersion))
  add(query_594209, "$from", newJString(From))
  add(path_594208, "subscriptionId", newJString(subscriptionId))
  add(query_594209, "$top", newJInt(Top))
  add(path_594208, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_594209, "$to", newJString(To))
  add(query_594209, "$filter", newJString(Filter))
  result = call_594207.call(path_594208, query_594209, nil, nil, nil)

var policyStatesSummarizeForResourceGroupLevelPolicyAssignment* = Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594193(
    name: "policyStatesSummarizeForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize", validator: validate_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594194,
    base: "", url: url_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_594195,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResource_594210 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesListQueryResultsForResource_594212(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "policyStatesResource" in path,
        "`policyStatesResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesResource"),
               (kind: ConstantSegment, value: "/queryResults")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesListQueryResultsForResource_594211(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Queries policy states for the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesResource: JString (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesResource` field"
  var valid_594213 = path.getOrDefault("policyStatesResource")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = newJString("default"))
  if valid_594213 != nil:
    section.add "policyStatesResource", valid_594213
  var valid_594214 = path.getOrDefault("resourceId")
  valid_594214 = validateParameter(valid_594214, JString, required = true,
                                 default = nil)
  if valid_594214 != nil:
    section.add "resourceId", valid_594214
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to expand policyEvaluationDetails, use $expand=policyEvaluationDetails
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $select: JString
  ##          : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $apply: JString
  ##         : OData apply expression for aggregations.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  var valid_594215 = query.getOrDefault("$orderby")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "$orderby", valid_594215
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594216 = query.getOrDefault("api-version")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "api-version", valid_594216
  var valid_594217 = query.getOrDefault("$expand")
  valid_594217 = validateParameter(valid_594217, JString, required = false,
                                 default = nil)
  if valid_594217 != nil:
    section.add "$expand", valid_594217
  var valid_594218 = query.getOrDefault("$from")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "$from", valid_594218
  var valid_594219 = query.getOrDefault("$top")
  valid_594219 = validateParameter(valid_594219, JInt, required = false, default = nil)
  if valid_594219 != nil:
    section.add "$top", valid_594219
  var valid_594220 = query.getOrDefault("$select")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "$select", valid_594220
  var valid_594221 = query.getOrDefault("$to")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = nil)
  if valid_594221 != nil:
    section.add "$to", valid_594221
  var valid_594222 = query.getOrDefault("$apply")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "$apply", valid_594222
  var valid_594223 = query.getOrDefault("$filter")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "$filter", valid_594223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594224: Call_PolicyStatesListQueryResultsForResource_594210;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource.
  ## 
  let valid = call_594224.validator(path, query, header, formData, body)
  let scheme = call_594224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594224.url(scheme.get, call_594224.host, call_594224.base,
                         call_594224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594224, url, valid)

proc call*(call_594225: Call_PolicyStatesListQueryResultsForResource_594210;
          apiVersion: string; resourceId: string; Orderby: string = "";
          Expand: string = ""; From: string = ""; Top: int = 0; Select: string = "";
          policyStatesResource: string = "default"; To: string = ""; Apply: string = "";
          Filter: string = ""): Recallable =
  ## policyStatesListQueryResultsForResource
  ## Queries policy states for the resource.
  ##   Orderby: string
  ##          : Ordering expression using OData notation. One or more comma-separated column names with an optional "desc" (the default) or "asc", e.g. "$orderby=PolicyAssignmentId, ResourceId asc".
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to expand policyEvaluationDetails, use $expand=policyEvaluationDetails
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   Select: string
  ##         : Select expression using OData notation. Limits the columns on each record to just those requested, e.g. "$select=PolicyAssignmentId, ResourceId".
  ##   policyStatesResource: string (required)
  ##                       : The virtual resource under PolicyStates resource type. In a given time range, 'latest' represents the latest policy state(s), whereas 'default' represents all policy state(s).
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Apply: string
  ##        : OData apply expression for aggregations.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594226 = newJObject()
  var query_594227 = newJObject()
  add(query_594227, "$orderby", newJString(Orderby))
  add(query_594227, "api-version", newJString(apiVersion))
  add(query_594227, "$expand", newJString(Expand))
  add(query_594227, "$from", newJString(From))
  add(query_594227, "$top", newJInt(Top))
  add(query_594227, "$select", newJString(Select))
  add(path_594226, "policyStatesResource", newJString(policyStatesResource))
  add(path_594226, "resourceId", newJString(resourceId))
  add(query_594227, "$to", newJString(To))
  add(query_594227, "$apply", newJString(Apply))
  add(query_594227, "$filter", newJString(Filter))
  result = call_594225.call(path_594226, query_594227, nil, nil, nil)

var policyStatesListQueryResultsForResource* = Call_PolicyStatesListQueryResultsForResource_594210(
    name: "policyStatesListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResource_594211, base: "",
    url: url_PolicyStatesListQueryResultsForResource_594212,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResource_594228 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesSummarizeForResource_594230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  assert "policyStatesSummaryResource" in path,
        "`policyStatesSummaryResource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/"),
               (kind: VariableSegment, value: "policyStatesSummaryResource"),
               (kind: ConstantSegment, value: "/summarize")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesSummarizeForResource_594229(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Summarizes policy states for the resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyStatesSummaryResource: JString (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   resourceId: JString (required)
  ##             : Resource ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `policyStatesSummaryResource` field"
  var valid_594231 = path.getOrDefault("policyStatesSummaryResource")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = newJString("latest"))
  if valid_594231 != nil:
    section.add "policyStatesSummaryResource", valid_594231
  var valid_594232 = path.getOrDefault("resourceId")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "resourceId", valid_594232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $from: JString
  ##        : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   $top: JInt
  ##       : Maximum number of records to return.
  ##   $to: JString
  ##      : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   $filter: JString
  ##          : OData filter expression.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594233 = query.getOrDefault("api-version")
  valid_594233 = validateParameter(valid_594233, JString, required = true,
                                 default = nil)
  if valid_594233 != nil:
    section.add "api-version", valid_594233
  var valid_594234 = query.getOrDefault("$from")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "$from", valid_594234
  var valid_594235 = query.getOrDefault("$top")
  valid_594235 = validateParameter(valid_594235, JInt, required = false, default = nil)
  if valid_594235 != nil:
    section.add "$top", valid_594235
  var valid_594236 = query.getOrDefault("$to")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "$to", valid_594236
  var valid_594237 = query.getOrDefault("$filter")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "$filter", valid_594237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594238: Call_PolicyStatesSummarizeForResource_594228;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resource.
  ## 
  let valid = call_594238.validator(path, query, header, formData, body)
  let scheme = call_594238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594238.url(scheme.get, call_594238.host, call_594238.base,
                         call_594238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594238, url, valid)

proc call*(call_594239: Call_PolicyStatesSummarizeForResource_594228;
          apiVersion: string; resourceId: string;
          policyStatesSummaryResource: string = "latest"; From: string = "";
          Top: int = 0; To: string = ""; Filter: string = ""): Recallable =
  ## policyStatesSummarizeForResource
  ## Summarizes policy states for the resource.
  ##   policyStatesSummaryResource: string (required)
  ##                              : The virtual resource under PolicyStates resource type for summarize action. In a given time range, 'latest' represents the latest policy state(s) and is the only allowed value.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   From: string
  ##       : ISO 8601 formatted timestamp specifying the start time of the interval to query. When not specified, the service uses ($to - 1-day).
  ##   Top: int
  ##      : Maximum number of records to return.
  ##   resourceId: string (required)
  ##             : Resource ID.
  ##   To: string
  ##     : ISO 8601 formatted timestamp specifying the end time of the interval to query. When not specified, the service uses request time.
  ##   Filter: string
  ##         : OData filter expression.
  var path_594240 = newJObject()
  var query_594241 = newJObject()
  add(path_594240, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_594241, "api-version", newJString(apiVersion))
  add(query_594241, "$from", newJString(From))
  add(query_594241, "$top", newJInt(Top))
  add(path_594240, "resourceId", newJString(resourceId))
  add(query_594241, "$to", newJString(To))
  add(query_594241, "$filter", newJString(Filter))
  result = call_594239.call(path_594240, query_594241, nil, nil, nil)

var policyStatesSummarizeForResource* = Call_PolicyStatesSummarizeForResource_594228(
    name: "policyStatesSummarizeForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForResource_594229, base: "",
    url: url_PolicyStatesSummarizeForResource_594230, schemes: {Scheme.Https})
type
  Call_PolicyStatesGetMetadata_594242 = ref object of OpenApiRestCall_593425
proc url_PolicyStatesGetMetadata_594244(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.PolicyInsights/policyStates/$metadata")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PolicyStatesGetMetadata_594243(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets OData metadata XML document.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_594245 = path.getOrDefault("scope")
  valid_594245 = validateParameter(valid_594245, JString, required = true,
                                 default = nil)
  if valid_594245 != nil:
    section.add "scope", valid_594245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594246 = query.getOrDefault("api-version")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "api-version", valid_594246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594247: Call_PolicyStatesGetMetadata_594242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_PolicyStatesGetMetadata_594242; apiVersion: string;
          scope: string): Recallable =
  ## policyStatesGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_594249 = newJObject()
  var query_594250 = newJObject()
  add(query_594250, "api-version", newJString(apiVersion))
  add(path_594249, "scope", newJString(scope))
  result = call_594248.call(path_594249, query_594250, nil, nil, nil)

var policyStatesGetMetadata* = Call_PolicyStatesGetMetadata_594242(
    name: "policyStatesGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyStates/$metadata",
    validator: validate_PolicyStatesGetMetadata_594243, base: "",
    url: url_PolicyStatesGetMetadata_594244, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

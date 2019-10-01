
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
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
  macServiceName = "policyinsights-policyStates"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567880 = ref object of OpenApiRestCall_567658
proc url_OperationsList_567882(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567881(path: JsonNode; query: JsonNode;
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
  var valid_568041 = query.getOrDefault("api-version")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "api-version", valid_568041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568064: Call_OperationsList_567880; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists available operations.
  ## 
  let valid = call_568064.validator(path, query, header, formData, body)
  let scheme = call_568064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568064.url(scheme.get, call_568064.host, call_568064.base,
                         call_568064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568064, url, valid)

proc call*(call_568135: Call_OperationsList_567880; apiVersion: string): Recallable =
  ## operationsList
  ## Lists available operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568136 = newJObject()
  add(query_568136, "api-version", newJString(apiVersion))
  result = call_568135.call(nil, query_568136, nil, nil, nil)

var operationsList* = Call_OperationsList_567880(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.PolicyInsights/operations",
    validator: validate_OperationsList_567881, base: "", url: url_OperationsList_567882,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForManagementGroup_568176 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForManagementGroup_568178(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForManagementGroup_568177(
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
  var valid_568194 = path.getOrDefault("managementGroupName")
  valid_568194 = validateParameter(valid_568194, JString, required = true,
                                 default = nil)
  if valid_568194 != nil:
    section.add "managementGroupName", valid_568194
  var valid_568208 = path.getOrDefault("managementGroupsNamespace")
  valid_568208 = validateParameter(valid_568208, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568208 != nil:
    section.add "managementGroupsNamespace", valid_568208
  var valid_568209 = path.getOrDefault("policyStatesResource")
  valid_568209 = validateParameter(valid_568209, JString, required = true,
                                 default = newJString("default"))
  if valid_568209 != nil:
    section.add "policyStatesResource", valid_568209
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
  var valid_568210 = query.getOrDefault("$orderby")
  valid_568210 = validateParameter(valid_568210, JString, required = false,
                                 default = nil)
  if valid_568210 != nil:
    section.add "$orderby", valid_568210
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568211 = query.getOrDefault("api-version")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "api-version", valid_568211
  var valid_568212 = query.getOrDefault("$from")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$from", valid_568212
  var valid_568213 = query.getOrDefault("$top")
  valid_568213 = validateParameter(valid_568213, JInt, required = false, default = nil)
  if valid_568213 != nil:
    section.add "$top", valid_568213
  var valid_568214 = query.getOrDefault("$select")
  valid_568214 = validateParameter(valid_568214, JString, required = false,
                                 default = nil)
  if valid_568214 != nil:
    section.add "$select", valid_568214
  var valid_568215 = query.getOrDefault("$to")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = nil)
  if valid_568215 != nil:
    section.add "$to", valid_568215
  var valid_568216 = query.getOrDefault("$apply")
  valid_568216 = validateParameter(valid_568216, JString, required = false,
                                 default = nil)
  if valid_568216 != nil:
    section.add "$apply", valid_568216
  var valid_568217 = query.getOrDefault("$filter")
  valid_568217 = validateParameter(valid_568217, JString, required = false,
                                 default = nil)
  if valid_568217 != nil:
    section.add "$filter", valid_568217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568218: Call_PolicyStatesListQueryResultsForManagementGroup_568176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the management group.
  ## 
  let valid = call_568218.validator(path, query, header, formData, body)
  let scheme = call_568218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568218.url(scheme.get, call_568218.host, call_568218.base,
                         call_568218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568218, url, valid)

proc call*(call_568219: Call_PolicyStatesListQueryResultsForManagementGroup_568176;
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
  var path_568220 = newJObject()
  var query_568221 = newJObject()
  add(path_568220, "managementGroupName", newJString(managementGroupName))
  add(path_568220, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(query_568221, "$orderby", newJString(Orderby))
  add(query_568221, "api-version", newJString(apiVersion))
  add(query_568221, "$from", newJString(From))
  add(query_568221, "$top", newJInt(Top))
  add(query_568221, "$select", newJString(Select))
  add(path_568220, "policyStatesResource", newJString(policyStatesResource))
  add(query_568221, "$to", newJString(To))
  add(query_568221, "$apply", newJString(Apply))
  add(query_568221, "$filter", newJString(Filter))
  result = call_568219.call(path_568220, query_568221, nil, nil, nil)

var policyStatesListQueryResultsForManagementGroup* = Call_PolicyStatesListQueryResultsForManagementGroup_568176(
    name: "policyStatesListQueryResultsForManagementGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForManagementGroup_568177,
    base: "", url: url_PolicyStatesListQueryResultsForManagementGroup_568178,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForManagementGroup_568222 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForManagementGroup_568224(protocol: Scheme;
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

proc validate_PolicyStatesSummarizeForManagementGroup_568223(path: JsonNode;
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
  var valid_568225 = path.getOrDefault("managementGroupName")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "managementGroupName", valid_568225
  var valid_568226 = path.getOrDefault("managementGroupsNamespace")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = newJString("Microsoft.Management"))
  if valid_568226 != nil:
    section.add "managementGroupsNamespace", valid_568226
  var valid_568227 = path.getOrDefault("policyStatesSummaryResource")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = newJString("latest"))
  if valid_568227 != nil:
    section.add "policyStatesSummaryResource", valid_568227
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
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  var valid_568229 = query.getOrDefault("$from")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = nil)
  if valid_568229 != nil:
    section.add "$from", valid_568229
  var valid_568230 = query.getOrDefault("$top")
  valid_568230 = validateParameter(valid_568230, JInt, required = false, default = nil)
  if valid_568230 != nil:
    section.add "$top", valid_568230
  var valid_568231 = query.getOrDefault("$to")
  valid_568231 = validateParameter(valid_568231, JString, required = false,
                                 default = nil)
  if valid_568231 != nil:
    section.add "$to", valid_568231
  var valid_568232 = query.getOrDefault("$filter")
  valid_568232 = validateParameter(valid_568232, JString, required = false,
                                 default = nil)
  if valid_568232 != nil:
    section.add "$filter", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_PolicyStatesSummarizeForManagementGroup_568222;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the management group.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_PolicyStatesSummarizeForManagementGroup_568222;
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
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "managementGroupName", newJString(managementGroupName))
  add(path_568235, "managementGroupsNamespace",
      newJString(managementGroupsNamespace))
  add(path_568235, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_568236, "api-version", newJString(apiVersion))
  add(query_568236, "$from", newJString(From))
  add(query_568236, "$top", newJInt(Top))
  add(query_568236, "$to", newJString(To))
  add(query_568236, "$filter", newJString(Filter))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var policyStatesSummarizeForManagementGroup* = Call_PolicyStatesSummarizeForManagementGroup_568222(
    name: "policyStatesSummarizeForManagementGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/providers/{managementGroupsNamespace}/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForManagementGroup_568223, base: "",
    url: url_PolicyStatesSummarizeForManagementGroup_568224,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscription_568237 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForSubscription_568239(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForSubscription_568238(path: JsonNode;
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
  var valid_568240 = path.getOrDefault("subscriptionId")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "subscriptionId", valid_568240
  var valid_568241 = path.getOrDefault("policyStatesResource")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = newJString("default"))
  if valid_568241 != nil:
    section.add "policyStatesResource", valid_568241
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
  var valid_568242 = query.getOrDefault("$orderby")
  valid_568242 = validateParameter(valid_568242, JString, required = false,
                                 default = nil)
  if valid_568242 != nil:
    section.add "$orderby", valid_568242
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  var valid_568244 = query.getOrDefault("$from")
  valid_568244 = validateParameter(valid_568244, JString, required = false,
                                 default = nil)
  if valid_568244 != nil:
    section.add "$from", valid_568244
  var valid_568245 = query.getOrDefault("$top")
  valid_568245 = validateParameter(valid_568245, JInt, required = false, default = nil)
  if valid_568245 != nil:
    section.add "$top", valid_568245
  var valid_568246 = query.getOrDefault("$select")
  valid_568246 = validateParameter(valid_568246, JString, required = false,
                                 default = nil)
  if valid_568246 != nil:
    section.add "$select", valid_568246
  var valid_568247 = query.getOrDefault("$to")
  valid_568247 = validateParameter(valid_568247, JString, required = false,
                                 default = nil)
  if valid_568247 != nil:
    section.add "$to", valid_568247
  var valid_568248 = query.getOrDefault("$apply")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = nil)
  if valid_568248 != nil:
    section.add "$apply", valid_568248
  var valid_568249 = query.getOrDefault("$filter")
  valid_568249 = validateParameter(valid_568249, JString, required = false,
                                 default = nil)
  if valid_568249 != nil:
    section.add "$filter", valid_568249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568250: Call_PolicyStatesListQueryResultsForSubscription_568237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the subscription.
  ## 
  let valid = call_568250.validator(path, query, header, formData, body)
  let scheme = call_568250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568250.url(scheme.get, call_568250.host, call_568250.base,
                         call_568250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568250, url, valid)

proc call*(call_568251: Call_PolicyStatesListQueryResultsForSubscription_568237;
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
  var path_568252 = newJObject()
  var query_568253 = newJObject()
  add(query_568253, "$orderby", newJString(Orderby))
  add(query_568253, "api-version", newJString(apiVersion))
  add(query_568253, "$from", newJString(From))
  add(path_568252, "subscriptionId", newJString(subscriptionId))
  add(query_568253, "$top", newJInt(Top))
  add(query_568253, "$select", newJString(Select))
  add(path_568252, "policyStatesResource", newJString(policyStatesResource))
  add(query_568253, "$to", newJString(To))
  add(query_568253, "$apply", newJString(Apply))
  add(query_568253, "$filter", newJString(Filter))
  result = call_568251.call(path_568252, query_568253, nil, nil, nil)

var policyStatesListQueryResultsForSubscription* = Call_PolicyStatesListQueryResultsForSubscription_568237(
    name: "policyStatesListQueryResultsForSubscription",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForSubscription_568238,
    base: "", url: url_PolicyStatesListQueryResultsForSubscription_568239,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForSubscription_568254 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForSubscription_568256(protocol: Scheme;
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

proc validate_PolicyStatesSummarizeForSubscription_568255(path: JsonNode;
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
  var valid_568257 = path.getOrDefault("policyStatesSummaryResource")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = newJString("latest"))
  if valid_568257 != nil:
    section.add "policyStatesSummaryResource", valid_568257
  var valid_568258 = path.getOrDefault("subscriptionId")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "subscriptionId", valid_568258
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
  var valid_568259 = query.getOrDefault("api-version")
  valid_568259 = validateParameter(valid_568259, JString, required = true,
                                 default = nil)
  if valid_568259 != nil:
    section.add "api-version", valid_568259
  var valid_568260 = query.getOrDefault("$from")
  valid_568260 = validateParameter(valid_568260, JString, required = false,
                                 default = nil)
  if valid_568260 != nil:
    section.add "$from", valid_568260
  var valid_568261 = query.getOrDefault("$top")
  valid_568261 = validateParameter(valid_568261, JInt, required = false, default = nil)
  if valid_568261 != nil:
    section.add "$top", valid_568261
  var valid_568262 = query.getOrDefault("$to")
  valid_568262 = validateParameter(valid_568262, JString, required = false,
                                 default = nil)
  if valid_568262 != nil:
    section.add "$to", valid_568262
  var valid_568263 = query.getOrDefault("$filter")
  valid_568263 = validateParameter(valid_568263, JString, required = false,
                                 default = nil)
  if valid_568263 != nil:
    section.add "$filter", valid_568263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_PolicyStatesSummarizeForSubscription_568254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the subscription.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_PolicyStatesSummarizeForSubscription_568254;
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
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  add(path_568266, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_568267, "api-version", newJString(apiVersion))
  add(query_568267, "$from", newJString(From))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  add(query_568267, "$top", newJInt(Top))
  add(query_568267, "$to", newJString(To))
  add(query_568267, "$filter", newJString(Filter))
  result = call_568265.call(path_568266, query_568267, nil, nil, nil)

var policyStatesSummarizeForSubscription* = Call_PolicyStatesSummarizeForSubscription_568254(
    name: "policyStatesSummarizeForSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForSubscription_568255, base: "",
    url: url_PolicyStatesSummarizeForSubscription_568256, schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568268 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568270(
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

proc validate_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568269(
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
  var valid_568271 = path.getOrDefault("authorizationNamespace")
  valid_568271 = validateParameter(valid_568271, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568271 != nil:
    section.add "authorizationNamespace", valid_568271
  var valid_568272 = path.getOrDefault("subscriptionId")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "subscriptionId", valid_568272
  var valid_568273 = path.getOrDefault("policyAssignmentName")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "policyAssignmentName", valid_568273
  var valid_568274 = path.getOrDefault("policyStatesResource")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = newJString("default"))
  if valid_568274 != nil:
    section.add "policyStatesResource", valid_568274
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
  var valid_568275 = query.getOrDefault("$orderby")
  valid_568275 = validateParameter(valid_568275, JString, required = false,
                                 default = nil)
  if valid_568275 != nil:
    section.add "$orderby", valid_568275
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568276 = query.getOrDefault("api-version")
  valid_568276 = validateParameter(valid_568276, JString, required = true,
                                 default = nil)
  if valid_568276 != nil:
    section.add "api-version", valid_568276
  var valid_568277 = query.getOrDefault("$from")
  valid_568277 = validateParameter(valid_568277, JString, required = false,
                                 default = nil)
  if valid_568277 != nil:
    section.add "$from", valid_568277
  var valid_568278 = query.getOrDefault("$top")
  valid_568278 = validateParameter(valid_568278, JInt, required = false, default = nil)
  if valid_568278 != nil:
    section.add "$top", valid_568278
  var valid_568279 = query.getOrDefault("$select")
  valid_568279 = validateParameter(valid_568279, JString, required = false,
                                 default = nil)
  if valid_568279 != nil:
    section.add "$select", valid_568279
  var valid_568280 = query.getOrDefault("$to")
  valid_568280 = validateParameter(valid_568280, JString, required = false,
                                 default = nil)
  if valid_568280 != nil:
    section.add "$to", valid_568280
  var valid_568281 = query.getOrDefault("$apply")
  valid_568281 = validateParameter(valid_568281, JString, required = false,
                                 default = nil)
  if valid_568281 != nil:
    section.add "$apply", valid_568281
  var valid_568282 = query.getOrDefault("$filter")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = nil)
  if valid_568282 != nil:
    section.add "$filter", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568283: Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy assignment.
  ## 
  let valid = call_568283.validator(path, query, header, formData, body)
  let scheme = call_568283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568283.url(scheme.get, call_568283.host, call_568283.base,
                         call_568283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568283, url, valid)

proc call*(call_568284: Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568268;
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
  var path_568285 = newJObject()
  var query_568286 = newJObject()
  add(query_568286, "$orderby", newJString(Orderby))
  add(path_568285, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568286, "api-version", newJString(apiVersion))
  add(query_568286, "$from", newJString(From))
  add(path_568285, "subscriptionId", newJString(subscriptionId))
  add(query_568286, "$top", newJInt(Top))
  add(query_568286, "$select", newJString(Select))
  add(path_568285, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568285, "policyStatesResource", newJString(policyStatesResource))
  add(query_568286, "$to", newJString(To))
  add(query_568286, "$apply", newJString(Apply))
  add(query_568286, "$filter", newJString(Filter))
  result = call_568284.call(path_568285, query_568286, nil, nil, nil)

var policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment* = Call_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568268(
    name: "policyStatesListQueryResultsForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults", validator: validate_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568269,
    base: "",
    url: url_PolicyStatesListQueryResultsForSubscriptionLevelPolicyAssignment_568270,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568287 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568289(
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

proc validate_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568288(
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
  var valid_568290 = path.getOrDefault("policyStatesSummaryResource")
  valid_568290 = validateParameter(valid_568290, JString, required = true,
                                 default = newJString("latest"))
  if valid_568290 != nil:
    section.add "policyStatesSummaryResource", valid_568290
  var valid_568291 = path.getOrDefault("authorizationNamespace")
  valid_568291 = validateParameter(valid_568291, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568291 != nil:
    section.add "authorizationNamespace", valid_568291
  var valid_568292 = path.getOrDefault("subscriptionId")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "subscriptionId", valid_568292
  var valid_568293 = path.getOrDefault("policyAssignmentName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "policyAssignmentName", valid_568293
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
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  var valid_568295 = query.getOrDefault("$from")
  valid_568295 = validateParameter(valid_568295, JString, required = false,
                                 default = nil)
  if valid_568295 != nil:
    section.add "$from", valid_568295
  var valid_568296 = query.getOrDefault("$top")
  valid_568296 = validateParameter(valid_568296, JInt, required = false, default = nil)
  if valid_568296 != nil:
    section.add "$top", valid_568296
  var valid_568297 = query.getOrDefault("$to")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "$to", valid_568297
  var valid_568298 = query.getOrDefault("$filter")
  valid_568298 = validateParameter(valid_568298, JString, required = false,
                                 default = nil)
  if valid_568298 != nil:
    section.add "$filter", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy assignment.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568287;
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
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(path_568301, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_568301, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568302, "api-version", newJString(apiVersion))
  add(query_568302, "$from", newJString(From))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  add(query_568302, "$top", newJInt(Top))
  add(path_568301, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_568302, "$to", newJString(To))
  add(query_568302, "$filter", newJString(Filter))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var policyStatesSummarizeForSubscriptionLevelPolicyAssignment* = Call_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568287(
    name: "policyStatesSummarizeForSubscriptionLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize", validator: validate_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568288,
    base: "", url: url_PolicyStatesSummarizeForSubscriptionLevelPolicyAssignment_568289,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForPolicyDefinition_568303 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForPolicyDefinition_568305(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForPolicyDefinition_568304(
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
  var valid_568306 = path.getOrDefault("authorizationNamespace")
  valid_568306 = validateParameter(valid_568306, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568306 != nil:
    section.add "authorizationNamespace", valid_568306
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("policyStatesResource")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = newJString("default"))
  if valid_568308 != nil:
    section.add "policyStatesResource", valid_568308
  var valid_568309 = path.getOrDefault("policyDefinitionName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "policyDefinitionName", valid_568309
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
  var valid_568310 = query.getOrDefault("$orderby")
  valid_568310 = validateParameter(valid_568310, JString, required = false,
                                 default = nil)
  if valid_568310 != nil:
    section.add "$orderby", valid_568310
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  var valid_568312 = query.getOrDefault("$from")
  valid_568312 = validateParameter(valid_568312, JString, required = false,
                                 default = nil)
  if valid_568312 != nil:
    section.add "$from", valid_568312
  var valid_568313 = query.getOrDefault("$top")
  valid_568313 = validateParameter(valid_568313, JInt, required = false, default = nil)
  if valid_568313 != nil:
    section.add "$top", valid_568313
  var valid_568314 = query.getOrDefault("$select")
  valid_568314 = validateParameter(valid_568314, JString, required = false,
                                 default = nil)
  if valid_568314 != nil:
    section.add "$select", valid_568314
  var valid_568315 = query.getOrDefault("$to")
  valid_568315 = validateParameter(valid_568315, JString, required = false,
                                 default = nil)
  if valid_568315 != nil:
    section.add "$to", valid_568315
  var valid_568316 = query.getOrDefault("$apply")
  valid_568316 = validateParameter(valid_568316, JString, required = false,
                                 default = nil)
  if valid_568316 != nil:
    section.add "$apply", valid_568316
  var valid_568317 = query.getOrDefault("$filter")
  valid_568317 = validateParameter(valid_568317, JString, required = false,
                                 default = nil)
  if valid_568317 != nil:
    section.add "$filter", valid_568317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568318: Call_PolicyStatesListQueryResultsForPolicyDefinition_568303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy definition.
  ## 
  let valid = call_568318.validator(path, query, header, formData, body)
  let scheme = call_568318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568318.url(scheme.get, call_568318.host, call_568318.base,
                         call_568318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568318, url, valid)

proc call*(call_568319: Call_PolicyStatesListQueryResultsForPolicyDefinition_568303;
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
  var path_568320 = newJObject()
  var query_568321 = newJObject()
  add(query_568321, "$orderby", newJString(Orderby))
  add(path_568320, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568321, "api-version", newJString(apiVersion))
  add(query_568321, "$from", newJString(From))
  add(path_568320, "subscriptionId", newJString(subscriptionId))
  add(query_568321, "$top", newJInt(Top))
  add(query_568321, "$select", newJString(Select))
  add(path_568320, "policyStatesResource", newJString(policyStatesResource))
  add(query_568321, "$to", newJString(To))
  add(query_568321, "$apply", newJString(Apply))
  add(path_568320, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_568321, "$filter", newJString(Filter))
  result = call_568319.call(path_568320, query_568321, nil, nil, nil)

var policyStatesListQueryResultsForPolicyDefinition* = Call_PolicyStatesListQueryResultsForPolicyDefinition_568303(
    name: "policyStatesListQueryResultsForPolicyDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForPolicyDefinition_568304,
    base: "", url: url_PolicyStatesListQueryResultsForPolicyDefinition_568305,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForPolicyDefinition_568322 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForPolicyDefinition_568324(protocol: Scheme;
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

proc validate_PolicyStatesSummarizeForPolicyDefinition_568323(path: JsonNode;
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
  var valid_568325 = path.getOrDefault("policyStatesSummaryResource")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = newJString("latest"))
  if valid_568325 != nil:
    section.add "policyStatesSummaryResource", valid_568325
  var valid_568326 = path.getOrDefault("authorizationNamespace")
  valid_568326 = validateParameter(valid_568326, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568326 != nil:
    section.add "authorizationNamespace", valid_568326
  var valid_568327 = path.getOrDefault("subscriptionId")
  valid_568327 = validateParameter(valid_568327, JString, required = true,
                                 default = nil)
  if valid_568327 != nil:
    section.add "subscriptionId", valid_568327
  var valid_568328 = path.getOrDefault("policyDefinitionName")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "policyDefinitionName", valid_568328
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
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  var valid_568330 = query.getOrDefault("$from")
  valid_568330 = validateParameter(valid_568330, JString, required = false,
                                 default = nil)
  if valid_568330 != nil:
    section.add "$from", valid_568330
  var valid_568331 = query.getOrDefault("$top")
  valid_568331 = validateParameter(valid_568331, JInt, required = false, default = nil)
  if valid_568331 != nil:
    section.add "$top", valid_568331
  var valid_568332 = query.getOrDefault("$to")
  valid_568332 = validateParameter(valid_568332, JString, required = false,
                                 default = nil)
  if valid_568332 != nil:
    section.add "$to", valid_568332
  var valid_568333 = query.getOrDefault("$filter")
  valid_568333 = validateParameter(valid_568333, JString, required = false,
                                 default = nil)
  if valid_568333 != nil:
    section.add "$filter", valid_568333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568334: Call_PolicyStatesSummarizeForPolicyDefinition_568322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy definition.
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_PolicyStatesSummarizeForPolicyDefinition_568322;
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
  var path_568336 = newJObject()
  var query_568337 = newJObject()
  add(path_568336, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_568336, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568337, "api-version", newJString(apiVersion))
  add(query_568337, "$from", newJString(From))
  add(path_568336, "subscriptionId", newJString(subscriptionId))
  add(query_568337, "$top", newJInt(Top))
  add(query_568337, "$to", newJString(To))
  add(path_568336, "policyDefinitionName", newJString(policyDefinitionName))
  add(query_568337, "$filter", newJString(Filter))
  result = call_568335.call(path_568336, query_568337, nil, nil, nil)

var policyStatesSummarizeForPolicyDefinition* = Call_PolicyStatesSummarizeForPolicyDefinition_568322(
    name: "policyStatesSummarizeForPolicyDefinition", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policyDefinitions/{policyDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForPolicyDefinition_568323, base: "",
    url: url_PolicyStatesSummarizeForPolicyDefinition_568324,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForPolicySetDefinition_568338 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForPolicySetDefinition_568340(
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

proc validate_PolicyStatesListQueryResultsForPolicySetDefinition_568339(
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
  var valid_568341 = path.getOrDefault("policySetDefinitionName")
  valid_568341 = validateParameter(valid_568341, JString, required = true,
                                 default = nil)
  if valid_568341 != nil:
    section.add "policySetDefinitionName", valid_568341
  var valid_568342 = path.getOrDefault("authorizationNamespace")
  valid_568342 = validateParameter(valid_568342, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568342 != nil:
    section.add "authorizationNamespace", valid_568342
  var valid_568343 = path.getOrDefault("subscriptionId")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "subscriptionId", valid_568343
  var valid_568344 = path.getOrDefault("policyStatesResource")
  valid_568344 = validateParameter(valid_568344, JString, required = true,
                                 default = newJString("default"))
  if valid_568344 != nil:
    section.add "policyStatesResource", valid_568344
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
  var valid_568345 = query.getOrDefault("$orderby")
  valid_568345 = validateParameter(valid_568345, JString, required = false,
                                 default = nil)
  if valid_568345 != nil:
    section.add "$orderby", valid_568345
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568346 = query.getOrDefault("api-version")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "api-version", valid_568346
  var valid_568347 = query.getOrDefault("$from")
  valid_568347 = validateParameter(valid_568347, JString, required = false,
                                 default = nil)
  if valid_568347 != nil:
    section.add "$from", valid_568347
  var valid_568348 = query.getOrDefault("$top")
  valid_568348 = validateParameter(valid_568348, JInt, required = false, default = nil)
  if valid_568348 != nil:
    section.add "$top", valid_568348
  var valid_568349 = query.getOrDefault("$select")
  valid_568349 = validateParameter(valid_568349, JString, required = false,
                                 default = nil)
  if valid_568349 != nil:
    section.add "$select", valid_568349
  var valid_568350 = query.getOrDefault("$to")
  valid_568350 = validateParameter(valid_568350, JString, required = false,
                                 default = nil)
  if valid_568350 != nil:
    section.add "$to", valid_568350
  var valid_568351 = query.getOrDefault("$apply")
  valid_568351 = validateParameter(valid_568351, JString, required = false,
                                 default = nil)
  if valid_568351 != nil:
    section.add "$apply", valid_568351
  var valid_568352 = query.getOrDefault("$filter")
  valid_568352 = validateParameter(valid_568352, JString, required = false,
                                 default = nil)
  if valid_568352 != nil:
    section.add "$filter", valid_568352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568353: Call_PolicyStatesListQueryResultsForPolicySetDefinition_568338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the subscription level policy set definition.
  ## 
  let valid = call_568353.validator(path, query, header, formData, body)
  let scheme = call_568353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568353.url(scheme.get, call_568353.host, call_568353.base,
                         call_568353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568353, url, valid)

proc call*(call_568354: Call_PolicyStatesListQueryResultsForPolicySetDefinition_568338;
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
  var path_568355 = newJObject()
  var query_568356 = newJObject()
  add(path_568355, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(query_568356, "$orderby", newJString(Orderby))
  add(path_568355, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568356, "api-version", newJString(apiVersion))
  add(query_568356, "$from", newJString(From))
  add(path_568355, "subscriptionId", newJString(subscriptionId))
  add(query_568356, "$top", newJInt(Top))
  add(query_568356, "$select", newJString(Select))
  add(path_568355, "policyStatesResource", newJString(policyStatesResource))
  add(query_568356, "$to", newJString(To))
  add(query_568356, "$apply", newJString(Apply))
  add(query_568356, "$filter", newJString(Filter))
  result = call_568354.call(path_568355, query_568356, nil, nil, nil)

var policyStatesListQueryResultsForPolicySetDefinition* = Call_PolicyStatesListQueryResultsForPolicySetDefinition_568338(
    name: "policyStatesListQueryResultsForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForPolicySetDefinition_568339,
    base: "", url: url_PolicyStatesListQueryResultsForPolicySetDefinition_568340,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForPolicySetDefinition_568357 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForPolicySetDefinition_568359(protocol: Scheme;
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

proc validate_PolicyStatesSummarizeForPolicySetDefinition_568358(path: JsonNode;
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
  var valid_568360 = path.getOrDefault("policySetDefinitionName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "policySetDefinitionName", valid_568360
  var valid_568361 = path.getOrDefault("policyStatesSummaryResource")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = newJString("latest"))
  if valid_568361 != nil:
    section.add "policyStatesSummaryResource", valid_568361
  var valid_568362 = path.getOrDefault("authorizationNamespace")
  valid_568362 = validateParameter(valid_568362, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568362 != nil:
    section.add "authorizationNamespace", valid_568362
  var valid_568363 = path.getOrDefault("subscriptionId")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "subscriptionId", valid_568363
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
  var valid_568364 = query.getOrDefault("api-version")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "api-version", valid_568364
  var valid_568365 = query.getOrDefault("$from")
  valid_568365 = validateParameter(valid_568365, JString, required = false,
                                 default = nil)
  if valid_568365 != nil:
    section.add "$from", valid_568365
  var valid_568366 = query.getOrDefault("$top")
  valid_568366 = validateParameter(valid_568366, JInt, required = false, default = nil)
  if valid_568366 != nil:
    section.add "$top", valid_568366
  var valid_568367 = query.getOrDefault("$to")
  valid_568367 = validateParameter(valid_568367, JString, required = false,
                                 default = nil)
  if valid_568367 != nil:
    section.add "$to", valid_568367
  var valid_568368 = query.getOrDefault("$filter")
  valid_568368 = validateParameter(valid_568368, JString, required = false,
                                 default = nil)
  if valid_568368 != nil:
    section.add "$filter", valid_568368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568369: Call_PolicyStatesSummarizeForPolicySetDefinition_568357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the subscription level policy set definition.
  ## 
  let valid = call_568369.validator(path, query, header, formData, body)
  let scheme = call_568369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568369.url(scheme.get, call_568369.host, call_568369.base,
                         call_568369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568369, url, valid)

proc call*(call_568370: Call_PolicyStatesSummarizeForPolicySetDefinition_568357;
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
  var path_568371 = newJObject()
  var query_568372 = newJObject()
  add(path_568371, "policySetDefinitionName", newJString(policySetDefinitionName))
  add(path_568371, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_568371, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568372, "api-version", newJString(apiVersion))
  add(query_568372, "$from", newJString(From))
  add(path_568371, "subscriptionId", newJString(subscriptionId))
  add(query_568372, "$top", newJInt(Top))
  add(query_568372, "$to", newJString(To))
  add(query_568372, "$filter", newJString(Filter))
  result = call_568370.call(path_568371, query_568372, nil, nil, nil)

var policyStatesSummarizeForPolicySetDefinition* = Call_PolicyStatesSummarizeForPolicySetDefinition_568357(
    name: "policyStatesSummarizeForPolicySetDefinition",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{authorizationNamespace}/policySetDefinitions/{policySetDefinitionName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForPolicySetDefinition_568358,
    base: "", url: url_PolicyStatesSummarizeForPolicySetDefinition_568359,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroup_568373 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForResourceGroup_568375(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForResourceGroup_568374(path: JsonNode;
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
  var valid_568376 = path.getOrDefault("resourceGroupName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "resourceGroupName", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  var valid_568378 = path.getOrDefault("policyStatesResource")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = newJString("default"))
  if valid_568378 != nil:
    section.add "policyStatesResource", valid_568378
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
  var valid_568379 = query.getOrDefault("$orderby")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "$orderby", valid_568379
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  var valid_568381 = query.getOrDefault("$from")
  valid_568381 = validateParameter(valid_568381, JString, required = false,
                                 default = nil)
  if valid_568381 != nil:
    section.add "$from", valid_568381
  var valid_568382 = query.getOrDefault("$top")
  valid_568382 = validateParameter(valid_568382, JInt, required = false, default = nil)
  if valid_568382 != nil:
    section.add "$top", valid_568382
  var valid_568383 = query.getOrDefault("$select")
  valid_568383 = validateParameter(valid_568383, JString, required = false,
                                 default = nil)
  if valid_568383 != nil:
    section.add "$select", valid_568383
  var valid_568384 = query.getOrDefault("$to")
  valid_568384 = validateParameter(valid_568384, JString, required = false,
                                 default = nil)
  if valid_568384 != nil:
    section.add "$to", valid_568384
  var valid_568385 = query.getOrDefault("$apply")
  valid_568385 = validateParameter(valid_568385, JString, required = false,
                                 default = nil)
  if valid_568385 != nil:
    section.add "$apply", valid_568385
  var valid_568386 = query.getOrDefault("$filter")
  valid_568386 = validateParameter(valid_568386, JString, required = false,
                                 default = nil)
  if valid_568386 != nil:
    section.add "$filter", valid_568386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568387: Call_PolicyStatesListQueryResultsForResourceGroup_568373;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resources under the resource group.
  ## 
  let valid = call_568387.validator(path, query, header, formData, body)
  let scheme = call_568387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568387.url(scheme.get, call_568387.host, call_568387.base,
                         call_568387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568387, url, valid)

proc call*(call_568388: Call_PolicyStatesListQueryResultsForResourceGroup_568373;
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
  var path_568389 = newJObject()
  var query_568390 = newJObject()
  add(query_568390, "$orderby", newJString(Orderby))
  add(path_568389, "resourceGroupName", newJString(resourceGroupName))
  add(query_568390, "api-version", newJString(apiVersion))
  add(query_568390, "$from", newJString(From))
  add(path_568389, "subscriptionId", newJString(subscriptionId))
  add(query_568390, "$top", newJInt(Top))
  add(query_568390, "$select", newJString(Select))
  add(path_568389, "policyStatesResource", newJString(policyStatesResource))
  add(query_568390, "$to", newJString(To))
  add(query_568390, "$apply", newJString(Apply))
  add(query_568390, "$filter", newJString(Filter))
  result = call_568388.call(path_568389, query_568390, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroup* = Call_PolicyStatesListQueryResultsForResourceGroup_568373(
    name: "policyStatesListQueryResultsForResourceGroup",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResourceGroup_568374,
    base: "", url: url_PolicyStatesListQueryResultsForResourceGroup_568375,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResourceGroup_568391 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForResourceGroup_568393(protocol: Scheme;
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

proc validate_PolicyStatesSummarizeForResourceGroup_568392(path: JsonNode;
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
  var valid_568394 = path.getOrDefault("resourceGroupName")
  valid_568394 = validateParameter(valid_568394, JString, required = true,
                                 default = nil)
  if valid_568394 != nil:
    section.add "resourceGroupName", valid_568394
  var valid_568395 = path.getOrDefault("policyStatesSummaryResource")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = newJString("latest"))
  if valid_568395 != nil:
    section.add "policyStatesSummaryResource", valid_568395
  var valid_568396 = path.getOrDefault("subscriptionId")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "subscriptionId", valid_568396
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
  var valid_568397 = query.getOrDefault("api-version")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "api-version", valid_568397
  var valid_568398 = query.getOrDefault("$from")
  valid_568398 = validateParameter(valid_568398, JString, required = false,
                                 default = nil)
  if valid_568398 != nil:
    section.add "$from", valid_568398
  var valid_568399 = query.getOrDefault("$top")
  valid_568399 = validateParameter(valid_568399, JInt, required = false, default = nil)
  if valid_568399 != nil:
    section.add "$top", valid_568399
  var valid_568400 = query.getOrDefault("$to")
  valid_568400 = validateParameter(valid_568400, JString, required = false,
                                 default = nil)
  if valid_568400 != nil:
    section.add "$to", valid_568400
  var valid_568401 = query.getOrDefault("$filter")
  valid_568401 = validateParameter(valid_568401, JString, required = false,
                                 default = nil)
  if valid_568401 != nil:
    section.add "$filter", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568402: Call_PolicyStatesSummarizeForResourceGroup_568391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resources under the resource group.
  ## 
  let valid = call_568402.validator(path, query, header, formData, body)
  let scheme = call_568402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568402.url(scheme.get, call_568402.host, call_568402.base,
                         call_568402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568402, url, valid)

proc call*(call_568403: Call_PolicyStatesSummarizeForResourceGroup_568391;
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
  var path_568404 = newJObject()
  var query_568405 = newJObject()
  add(path_568404, "resourceGroupName", newJString(resourceGroupName))
  add(path_568404, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_568405, "api-version", newJString(apiVersion))
  add(query_568405, "$from", newJString(From))
  add(path_568404, "subscriptionId", newJString(subscriptionId))
  add(query_568405, "$top", newJInt(Top))
  add(query_568405, "$to", newJString(To))
  add(query_568405, "$filter", newJString(Filter))
  result = call_568403.call(path_568404, query_568405, nil, nil, nil)

var policyStatesSummarizeForResourceGroup* = Call_PolicyStatesSummarizeForResourceGroup_568391(
    name: "policyStatesSummarizeForResourceGroup", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForResourceGroup_568392, base: "",
    url: url_PolicyStatesSummarizeForResourceGroup_568393, schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568406 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568408(
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

proc validate_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568407(
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
  var valid_568409 = path.getOrDefault("resourceGroupName")
  valid_568409 = validateParameter(valid_568409, JString, required = true,
                                 default = nil)
  if valid_568409 != nil:
    section.add "resourceGroupName", valid_568409
  var valid_568410 = path.getOrDefault("authorizationNamespace")
  valid_568410 = validateParameter(valid_568410, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568410 != nil:
    section.add "authorizationNamespace", valid_568410
  var valid_568411 = path.getOrDefault("subscriptionId")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "subscriptionId", valid_568411
  var valid_568412 = path.getOrDefault("policyAssignmentName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "policyAssignmentName", valid_568412
  var valid_568413 = path.getOrDefault("policyStatesResource")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = newJString("default"))
  if valid_568413 != nil:
    section.add "policyStatesResource", valid_568413
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
  var valid_568414 = query.getOrDefault("$orderby")
  valid_568414 = validateParameter(valid_568414, JString, required = false,
                                 default = nil)
  if valid_568414 != nil:
    section.add "$orderby", valid_568414
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  var valid_568416 = query.getOrDefault("$from")
  valid_568416 = validateParameter(valid_568416, JString, required = false,
                                 default = nil)
  if valid_568416 != nil:
    section.add "$from", valid_568416
  var valid_568417 = query.getOrDefault("$top")
  valid_568417 = validateParameter(valid_568417, JInt, required = false, default = nil)
  if valid_568417 != nil:
    section.add "$top", valid_568417
  var valid_568418 = query.getOrDefault("$select")
  valid_568418 = validateParameter(valid_568418, JString, required = false,
                                 default = nil)
  if valid_568418 != nil:
    section.add "$select", valid_568418
  var valid_568419 = query.getOrDefault("$to")
  valid_568419 = validateParameter(valid_568419, JString, required = false,
                                 default = nil)
  if valid_568419 != nil:
    section.add "$to", valid_568419
  var valid_568420 = query.getOrDefault("$apply")
  valid_568420 = validateParameter(valid_568420, JString, required = false,
                                 default = nil)
  if valid_568420 != nil:
    section.add "$apply", valid_568420
  var valid_568421 = query.getOrDefault("$filter")
  valid_568421 = validateParameter(valid_568421, JString, required = false,
                                 default = nil)
  if valid_568421 != nil:
    section.add "$filter", valid_568421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568422: Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568406;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource group level policy assignment.
  ## 
  let valid = call_568422.validator(path, query, header, formData, body)
  let scheme = call_568422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568422.url(scheme.get, call_568422.host, call_568422.base,
                         call_568422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568422, url, valid)

proc call*(call_568423: Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568406;
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
  var path_568424 = newJObject()
  var query_568425 = newJObject()
  add(query_568425, "$orderby", newJString(Orderby))
  add(path_568424, "resourceGroupName", newJString(resourceGroupName))
  add(path_568424, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568425, "api-version", newJString(apiVersion))
  add(query_568425, "$from", newJString(From))
  add(path_568424, "subscriptionId", newJString(subscriptionId))
  add(query_568425, "$top", newJInt(Top))
  add(query_568425, "$select", newJString(Select))
  add(path_568424, "policyAssignmentName", newJString(policyAssignmentName))
  add(path_568424, "policyStatesResource", newJString(policyStatesResource))
  add(query_568425, "$to", newJString(To))
  add(query_568425, "$apply", newJString(Apply))
  add(query_568425, "$filter", newJString(Filter))
  result = call_568423.call(path_568424, query_568425, nil, nil, nil)

var policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment* = Call_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568406(
    name: "policyStatesListQueryResultsForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults", validator: validate_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568407,
    base: "",
    url: url_PolicyStatesListQueryResultsForResourceGroupLevelPolicyAssignment_568408,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568426 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568428(
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

proc validate_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568427(
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
  var valid_568429 = path.getOrDefault("resourceGroupName")
  valid_568429 = validateParameter(valid_568429, JString, required = true,
                                 default = nil)
  if valid_568429 != nil:
    section.add "resourceGroupName", valid_568429
  var valid_568430 = path.getOrDefault("policyStatesSummaryResource")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = newJString("latest"))
  if valid_568430 != nil:
    section.add "policyStatesSummaryResource", valid_568430
  var valid_568431 = path.getOrDefault("authorizationNamespace")
  valid_568431 = validateParameter(valid_568431, JString, required = true, default = newJString(
      "Microsoft.Authorization"))
  if valid_568431 != nil:
    section.add "authorizationNamespace", valid_568431
  var valid_568432 = path.getOrDefault("subscriptionId")
  valid_568432 = validateParameter(valid_568432, JString, required = true,
                                 default = nil)
  if valid_568432 != nil:
    section.add "subscriptionId", valid_568432
  var valid_568433 = path.getOrDefault("policyAssignmentName")
  valid_568433 = validateParameter(valid_568433, JString, required = true,
                                 default = nil)
  if valid_568433 != nil:
    section.add "policyAssignmentName", valid_568433
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
  var valid_568434 = query.getOrDefault("api-version")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "api-version", valid_568434
  var valid_568435 = query.getOrDefault("$from")
  valid_568435 = validateParameter(valid_568435, JString, required = false,
                                 default = nil)
  if valid_568435 != nil:
    section.add "$from", valid_568435
  var valid_568436 = query.getOrDefault("$top")
  valid_568436 = validateParameter(valid_568436, JInt, required = false, default = nil)
  if valid_568436 != nil:
    section.add "$top", valid_568436
  var valid_568437 = query.getOrDefault("$to")
  valid_568437 = validateParameter(valid_568437, JString, required = false,
                                 default = nil)
  if valid_568437 != nil:
    section.add "$to", valid_568437
  var valid_568438 = query.getOrDefault("$filter")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "$filter", valid_568438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568426;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resource group level policy assignment.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568426;
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
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(path_568441, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(path_568441, "authorizationNamespace", newJString(authorizationNamespace))
  add(query_568442, "api-version", newJString(apiVersion))
  add(query_568442, "$from", newJString(From))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  add(query_568442, "$top", newJInt(Top))
  add(path_568441, "policyAssignmentName", newJString(policyAssignmentName))
  add(query_568442, "$to", newJString(To))
  add(query_568442, "$filter", newJString(Filter))
  result = call_568440.call(path_568441, query_568442, nil, nil, nil)

var policyStatesSummarizeForResourceGroupLevelPolicyAssignment* = Call_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568426(
    name: "policyStatesSummarizeForResourceGroupLevelPolicyAssignment",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{authorizationNamespace}/policyAssignments/{policyAssignmentName}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize", validator: validate_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568427,
    base: "", url: url_PolicyStatesSummarizeForResourceGroupLevelPolicyAssignment_568428,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesListQueryResultsForResource_568443 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesListQueryResultsForResource_568445(protocol: Scheme;
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

proc validate_PolicyStatesListQueryResultsForResource_568444(path: JsonNode;
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
  var valid_568446 = path.getOrDefault("policyStatesResource")
  valid_568446 = validateParameter(valid_568446, JString, required = true,
                                 default = newJString("default"))
  if valid_568446 != nil:
    section.add "policyStatesResource", valid_568446
  var valid_568447 = path.getOrDefault("resourceId")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceId", valid_568447
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
  var valid_568448 = query.getOrDefault("$orderby")
  valid_568448 = validateParameter(valid_568448, JString, required = false,
                                 default = nil)
  if valid_568448 != nil:
    section.add "$orderby", valid_568448
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  var valid_568450 = query.getOrDefault("$expand")
  valid_568450 = validateParameter(valid_568450, JString, required = false,
                                 default = nil)
  if valid_568450 != nil:
    section.add "$expand", valid_568450
  var valid_568451 = query.getOrDefault("$from")
  valid_568451 = validateParameter(valid_568451, JString, required = false,
                                 default = nil)
  if valid_568451 != nil:
    section.add "$from", valid_568451
  var valid_568452 = query.getOrDefault("$top")
  valid_568452 = validateParameter(valid_568452, JInt, required = false, default = nil)
  if valid_568452 != nil:
    section.add "$top", valid_568452
  var valid_568453 = query.getOrDefault("$select")
  valid_568453 = validateParameter(valid_568453, JString, required = false,
                                 default = nil)
  if valid_568453 != nil:
    section.add "$select", valid_568453
  var valid_568454 = query.getOrDefault("$to")
  valid_568454 = validateParameter(valid_568454, JString, required = false,
                                 default = nil)
  if valid_568454 != nil:
    section.add "$to", valid_568454
  var valid_568455 = query.getOrDefault("$apply")
  valid_568455 = validateParameter(valid_568455, JString, required = false,
                                 default = nil)
  if valid_568455 != nil:
    section.add "$apply", valid_568455
  var valid_568456 = query.getOrDefault("$filter")
  valid_568456 = validateParameter(valid_568456, JString, required = false,
                                 default = nil)
  if valid_568456 != nil:
    section.add "$filter", valid_568456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568457: Call_PolicyStatesListQueryResultsForResource_568443;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Queries policy states for the resource.
  ## 
  let valid = call_568457.validator(path, query, header, formData, body)
  let scheme = call_568457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568457.url(scheme.get, call_568457.host, call_568457.base,
                         call_568457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568457, url, valid)

proc call*(call_568458: Call_PolicyStatesListQueryResultsForResource_568443;
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
  var path_568459 = newJObject()
  var query_568460 = newJObject()
  add(query_568460, "$orderby", newJString(Orderby))
  add(query_568460, "api-version", newJString(apiVersion))
  add(query_568460, "$expand", newJString(Expand))
  add(query_568460, "$from", newJString(From))
  add(query_568460, "$top", newJInt(Top))
  add(query_568460, "$select", newJString(Select))
  add(path_568459, "policyStatesResource", newJString(policyStatesResource))
  add(path_568459, "resourceId", newJString(resourceId))
  add(query_568460, "$to", newJString(To))
  add(query_568460, "$apply", newJString(Apply))
  add(query_568460, "$filter", newJString(Filter))
  result = call_568458.call(path_568459, query_568460, nil, nil, nil)

var policyStatesListQueryResultsForResource* = Call_PolicyStatesListQueryResultsForResource_568443(
    name: "policyStatesListQueryResultsForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesResource}/queryResults",
    validator: validate_PolicyStatesListQueryResultsForResource_568444, base: "",
    url: url_PolicyStatesListQueryResultsForResource_568445,
    schemes: {Scheme.Https})
type
  Call_PolicyStatesSummarizeForResource_568461 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesSummarizeForResource_568463(protocol: Scheme; host: string;
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

proc validate_PolicyStatesSummarizeForResource_568462(path: JsonNode;
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
  var valid_568464 = path.getOrDefault("policyStatesSummaryResource")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = newJString("latest"))
  if valid_568464 != nil:
    section.add "policyStatesSummaryResource", valid_568464
  var valid_568465 = path.getOrDefault("resourceId")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "resourceId", valid_568465
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
  var valid_568466 = query.getOrDefault("api-version")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "api-version", valid_568466
  var valid_568467 = query.getOrDefault("$from")
  valid_568467 = validateParameter(valid_568467, JString, required = false,
                                 default = nil)
  if valid_568467 != nil:
    section.add "$from", valid_568467
  var valid_568468 = query.getOrDefault("$top")
  valid_568468 = validateParameter(valid_568468, JInt, required = false, default = nil)
  if valid_568468 != nil:
    section.add "$top", valid_568468
  var valid_568469 = query.getOrDefault("$to")
  valid_568469 = validateParameter(valid_568469, JString, required = false,
                                 default = nil)
  if valid_568469 != nil:
    section.add "$to", valid_568469
  var valid_568470 = query.getOrDefault("$filter")
  valid_568470 = validateParameter(valid_568470, JString, required = false,
                                 default = nil)
  if valid_568470 != nil:
    section.add "$filter", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_PolicyStatesSummarizeForResource_568461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Summarizes policy states for the resource.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_PolicyStatesSummarizeForResource_568461;
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
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(path_568473, "policyStatesSummaryResource",
      newJString(policyStatesSummaryResource))
  add(query_568474, "api-version", newJString(apiVersion))
  add(query_568474, "$from", newJString(From))
  add(query_568474, "$top", newJInt(Top))
  add(path_568473, "resourceId", newJString(resourceId))
  add(query_568474, "$to", newJString(To))
  add(query_568474, "$filter", newJString(Filter))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var policyStatesSummarizeForResource* = Call_PolicyStatesSummarizeForResource_568461(
    name: "policyStatesSummarizeForResource", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/{resourceId}/providers/Microsoft.PolicyInsights/policyStates/{policyStatesSummaryResource}/summarize",
    validator: validate_PolicyStatesSummarizeForResource_568462, base: "",
    url: url_PolicyStatesSummarizeForResource_568463, schemes: {Scheme.Https})
type
  Call_PolicyStatesGetMetadata_568475 = ref object of OpenApiRestCall_567658
proc url_PolicyStatesGetMetadata_568477(protocol: Scheme; host: string; base: string;
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

proc validate_PolicyStatesGetMetadata_568476(path: JsonNode; query: JsonNode;
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
  var valid_568478 = path.getOrDefault("scope")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "scope", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568479 = query.getOrDefault("api-version")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "api-version", valid_568479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568480: Call_PolicyStatesGetMetadata_568475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets OData metadata XML document.
  ## 
  let valid = call_568480.validator(path, query, header, formData, body)
  let scheme = call_568480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568480.url(scheme.get, call_568480.host, call_568480.base,
                         call_568480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568480, url, valid)

proc call*(call_568481: Call_PolicyStatesGetMetadata_568475; apiVersion: string;
          scope: string): Recallable =
  ## policyStatesGetMetadata
  ## Gets OData metadata XML document.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : A valid scope, i.e. management group, subscription, resource group, or resource ID. Scope used has no effect on metadata returned.
  var path_568482 = newJObject()
  var query_568483 = newJObject()
  add(query_568483, "api-version", newJString(apiVersion))
  add(path_568482, "scope", newJString(scope))
  result = call_568481.call(path_568482, query_568483, nil, nil, nil)

var policyStatesGetMetadata* = Call_PolicyStatesGetMetadata_568475(
    name: "policyStatesGetMetadata", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.PolicyInsights/policyStates/$metadata",
    validator: validate_PolicyStatesGetMetadata_568476, base: "",
    url: url_PolicyStatesGetMetadata_568477, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

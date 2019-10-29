
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Security Insights
## version: 2019-01-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.SecurityInsights (Azure Security Insights) resource provider
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
  macServiceName = "securityinsights-SecurityInsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563787 = ref object of OpenApiRestCall_563565
proc url_OperationsList_563789(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563788(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all operations available Azure Security Insights Resource Provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563963 = query.getOrDefault("api-version")
  valid_563963 = validateParameter(valid_563963, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_563963 != nil:
    section.add "api-version", valid_563963
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563986: Call_OperationsList_563787; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all operations available Azure Security Insights Resource Provider.
  ## 
  let valid = call_563986.validator(path, query, header, formData, body)
  let scheme = call_563986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563986.url(scheme.get, call_563986.host, call_563986.base,
                         call_563986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563986, url, valid)

proc call*(call_564057: Call_OperationsList_563787;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## operationsList
  ## Lists all operations available Azure Security Insights Resource Provider.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  var query_564058 = newJObject()
  add(query_564058, "api-version", newJString(apiVersion))
  result = call_564057.call(nil, query_564058, nil, nil, nil)

var operationsList* = Call_OperationsList_563787(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.SecurityInsights/operations",
    validator: validate_OperationsList_563788, base: "", url: url_OperationsList_563789,
    schemes: {Scheme.Https})
type
  Call_CasesAggregationsGet_564098 = ref object of OpenApiRestCall_563565
proc url_CasesAggregationsGet_564100(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "aggregationsName" in path,
        "`aggregationsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/aggregations/"),
               (kind: VariableSegment, value: "aggregationsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesAggregationsGet_564099(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get aggregative result for the given resources under the defined workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   aggregationsName: JString (required)
  ##                   : The aggregation name. Supports - Cases
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564115 = path.getOrDefault("subscriptionId")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "subscriptionId", valid_564115
  var valid_564116 = path.getOrDefault("aggregationsName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "aggregationsName", valid_564116
  var valid_564117 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "operationalInsightsResourceProvider", valid_564117
  var valid_564118 = path.getOrDefault("resourceGroupName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceGroupName", valid_564118
  var valid_564119 = path.getOrDefault("workspaceName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "workspaceName", valid_564119
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564120 = query.getOrDefault("api-version")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564120 != nil:
    section.add "api-version", valid_564120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_CasesAggregationsGet_564098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get aggregative result for the given resources under the defined workspace
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_CasesAggregationsGet_564098; subscriptionId: string;
          aggregationsName: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesAggregationsGet
  ## Get aggregative result for the given resources under the defined workspace
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   aggregationsName: string (required)
  ##                   : The aggregation name. Supports - Cases
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(path_564123, "aggregationsName", newJString(aggregationsName))
  add(path_564123, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564123, "resourceGroupName", newJString(resourceGroupName))
  add(path_564123, "workspaceName", newJString(workspaceName))
  result = call_564122.call(path_564123, query_564124, nil, nil, nil)

var casesAggregationsGet* = Call_CasesAggregationsGet_564098(
    name: "casesAggregationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/aggregations/{aggregationsName}",
    validator: validate_CasesAggregationsGet_564099, base: "",
    url: url_CasesAggregationsGet_564100, schemes: {Scheme.Https})
type
  Call_AlertRuleTemplatesList_564125 = ref object of OpenApiRestCall_563565
proc url_AlertRuleTemplatesList_564127(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRuleTemplates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRuleTemplatesList_564126(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all alert rule templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564128 = path.getOrDefault("subscriptionId")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "subscriptionId", valid_564128
  var valid_564129 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "operationalInsightsResourceProvider", valid_564129
  var valid_564130 = path.getOrDefault("resourceGroupName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "resourceGroupName", valid_564130
  var valid_564131 = path.getOrDefault("workspaceName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "workspaceName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_AlertRuleTemplatesList_564125; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all alert rule templates.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_AlertRuleTemplatesList_564125; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRuleTemplatesList
  ## Gets all alert rule templates.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  add(path_564135, "workspaceName", newJString(workspaceName))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var alertRuleTemplatesList* = Call_AlertRuleTemplatesList_564125(
    name: "alertRuleTemplatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRuleTemplates",
    validator: validate_AlertRuleTemplatesList_564126, base: "",
    url: url_AlertRuleTemplatesList_564127, schemes: {Scheme.Https})
type
  Call_AlertRuleTemplatesGet_564137 = ref object of OpenApiRestCall_563565
proc url_AlertRuleTemplatesGet_564139(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "alertRuleTemplateId" in path,
        "`alertRuleTemplateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRuleTemplates/"),
               (kind: VariableSegment, value: "alertRuleTemplateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRuleTemplatesGet_564138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert rule template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertRuleTemplateId: JString (required)
  ##                      : Alert rule template ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("alertRuleTemplateId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "alertRuleTemplateId", valid_564141
  var valid_564142 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "operationalInsightsResourceProvider", valid_564142
  var valid_564143 = path.getOrDefault("resourceGroupName")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "resourceGroupName", valid_564143
  var valid_564144 = path.getOrDefault("workspaceName")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "workspaceName", valid_564144
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564145 = query.getOrDefault("api-version")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564145 != nil:
    section.add "api-version", valid_564145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564146: Call_AlertRuleTemplatesGet_564137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert rule template.
  ## 
  let valid = call_564146.validator(path, query, header, formData, body)
  let scheme = call_564146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564146.url(scheme.get, call_564146.host, call_564146.base,
                         call_564146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564146, url, valid)

proc call*(call_564147: Call_AlertRuleTemplatesGet_564137; subscriptionId: string;
          alertRuleTemplateId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRuleTemplatesGet
  ## Gets the alert rule template.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertRuleTemplateId: string (required)
  ##                      : Alert rule template ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564148 = newJObject()
  var query_564149 = newJObject()
  add(query_564149, "api-version", newJString(apiVersion))
  add(path_564148, "subscriptionId", newJString(subscriptionId))
  add(path_564148, "alertRuleTemplateId", newJString(alertRuleTemplateId))
  add(path_564148, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564148, "resourceGroupName", newJString(resourceGroupName))
  add(path_564148, "workspaceName", newJString(workspaceName))
  result = call_564147.call(path_564148, query_564149, nil, nil, nil)

var alertRuleTemplatesGet* = Call_AlertRuleTemplatesGet_564137(
    name: "alertRuleTemplatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRuleTemplates/{alertRuleTemplateId}",
    validator: validate_AlertRuleTemplatesGet_564138, base: "",
    url: url_AlertRuleTemplatesGet_564139, schemes: {Scheme.Https})
type
  Call_AlertRulesList_564150 = ref object of OpenApiRestCall_563565
proc url_AlertRulesList_564152(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesList_564151(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all alert rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564153 = path.getOrDefault("subscriptionId")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "subscriptionId", valid_564153
  var valid_564154 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "operationalInsightsResourceProvider", valid_564154
  var valid_564155 = path.getOrDefault("resourceGroupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "resourceGroupName", valid_564155
  var valid_564156 = path.getOrDefault("workspaceName")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "workspaceName", valid_564156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564157 = query.getOrDefault("api-version")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564157 != nil:
    section.add "api-version", valid_564157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564158: Call_AlertRulesList_564150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all alert rules.
  ## 
  let valid = call_564158.validator(path, query, header, formData, body)
  let scheme = call_564158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564158.url(scheme.get, call_564158.host, call_564158.base,
                         call_564158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564158, url, valid)

proc call*(call_564159: Call_AlertRulesList_564150; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesList
  ## Gets all alert rules.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564160 = newJObject()
  var query_564161 = newJObject()
  add(query_564161, "api-version", newJString(apiVersion))
  add(path_564160, "subscriptionId", newJString(subscriptionId))
  add(path_564160, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564160, "resourceGroupName", newJString(resourceGroupName))
  add(path_564160, "workspaceName", newJString(workspaceName))
  result = call_564159.call(path_564160, query_564161, nil, nil, nil)

var alertRulesList* = Call_AlertRulesList_564150(name: "alertRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules",
    validator: validate_AlertRulesList_564151, base: "", url: url_AlertRulesList_564152,
    schemes: {Scheme.Https})
type
  Call_AlertRulesCreateOrUpdate_564175 = ref object of OpenApiRestCall_563565
proc url_AlertRulesCreateOrUpdate_564177(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesCreateOrUpdate_564176(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564178 = path.getOrDefault("ruleId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "ruleId", valid_564178
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "operationalInsightsResourceProvider", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("workspaceName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "workspaceName", valid_564182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564183 = query.getOrDefault("api-version")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564183 != nil:
    section.add "api-version", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   alertRule: JObject (required)
  ##            : The alert rule
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564185: Call_AlertRulesCreateOrUpdate_564175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the alert rule.
  ## 
  let valid = call_564185.validator(path, query, header, formData, body)
  let scheme = call_564185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564185.url(scheme.get, call_564185.host, call_564185.base,
                         call_564185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564185, url, valid)

proc call*(call_564186: Call_AlertRulesCreateOrUpdate_564175; ruleId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string; alertRule: JsonNode;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesCreateOrUpdate
  ## Creates or updates the alert rule.
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   alertRule: JObject (required)
  ##            : The alert rule
  var path_564187 = newJObject()
  var query_564188 = newJObject()
  var body_564189 = newJObject()
  add(path_564187, "ruleId", newJString(ruleId))
  add(query_564188, "api-version", newJString(apiVersion))
  add(path_564187, "subscriptionId", newJString(subscriptionId))
  add(path_564187, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564187, "resourceGroupName", newJString(resourceGroupName))
  add(path_564187, "workspaceName", newJString(workspaceName))
  if alertRule != nil:
    body_564189 = alertRule
  result = call_564186.call(path_564187, query_564188, nil, nil, body_564189)

var alertRulesCreateOrUpdate* = Call_AlertRulesCreateOrUpdate_564175(
    name: "alertRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesCreateOrUpdate_564176, base: "",
    url: url_AlertRulesCreateOrUpdate_564177, schemes: {Scheme.Https})
type
  Call_AlertRulesGet_564162 = ref object of OpenApiRestCall_563565
proc url_AlertRulesGet_564164(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesGet_564163(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564165 = path.getOrDefault("ruleId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "ruleId", valid_564165
  var valid_564166 = path.getOrDefault("subscriptionId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "subscriptionId", valid_564166
  var valid_564167 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "operationalInsightsResourceProvider", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  var valid_564169 = path.getOrDefault("workspaceName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "workspaceName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564171: Call_AlertRulesGet_564162; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert rule.
  ## 
  let valid = call_564171.validator(path, query, header, formData, body)
  let scheme = call_564171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564171.url(scheme.get, call_564171.host, call_564171.base,
                         call_564171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564171, url, valid)

proc call*(call_564172: Call_AlertRulesGet_564162; ruleId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesGet
  ## Gets the alert rule.
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564173 = newJObject()
  var query_564174 = newJObject()
  add(path_564173, "ruleId", newJString(ruleId))
  add(query_564174, "api-version", newJString(apiVersion))
  add(path_564173, "subscriptionId", newJString(subscriptionId))
  add(path_564173, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564173, "resourceGroupName", newJString(resourceGroupName))
  add(path_564173, "workspaceName", newJString(workspaceName))
  result = call_564172.call(path_564173, query_564174, nil, nil, nil)

var alertRulesGet* = Call_AlertRulesGet_564162(name: "alertRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesGet_564163, base: "", url: url_AlertRulesGet_564164,
    schemes: {Scheme.Https})
type
  Call_AlertRulesDelete_564190 = ref object of OpenApiRestCall_563565
proc url_AlertRulesDelete_564192(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesDelete_564191(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564193 = path.getOrDefault("ruleId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "ruleId", valid_564193
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "operationalInsightsResourceProvider", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  var valid_564197 = path.getOrDefault("workspaceName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "workspaceName", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_AlertRulesDelete_564190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the alert rule.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_AlertRulesDelete_564190; ruleId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesDelete
  ## Delete the alert rule.
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(path_564201, "ruleId", newJString(ruleId))
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(path_564201, "workspaceName", newJString(workspaceName))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var alertRulesDelete* = Call_AlertRulesDelete_564190(name: "alertRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesDelete_564191, base: "",
    url: url_AlertRulesDelete_564192, schemes: {Scheme.Https})
type
  Call_ActionsListByAlertRule_564203 = ref object of OpenApiRestCall_563565
proc url_ActionsListByAlertRule_564205(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ActionsListByAlertRule_564204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all actions of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564206 = path.getOrDefault("ruleId")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "ruleId", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "operationalInsightsResourceProvider", valid_564208
  var valid_564209 = path.getOrDefault("resourceGroupName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "resourceGroupName", valid_564209
  var valid_564210 = path.getOrDefault("workspaceName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "workspaceName", valid_564210
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564211 = query.getOrDefault("api-version")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564211 != nil:
    section.add "api-version", valid_564211
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_ActionsListByAlertRule_564203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all actions of alert rule.
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_ActionsListByAlertRule_564203; ruleId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## actionsListByAlertRule
  ## Gets all actions of alert rule.
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  add(path_564214, "ruleId", newJString(ruleId))
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  add(path_564214, "workspaceName", newJString(workspaceName))
  result = call_564213.call(path_564214, query_564215, nil, nil, nil)

var actionsListByAlertRule* = Call_ActionsListByAlertRule_564203(
    name: "actionsListByAlertRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions",
    validator: validate_ActionsListByAlertRule_564204, base: "",
    url: url_ActionsListByAlertRule_564205, schemes: {Scheme.Https})
type
  Call_AlertRulesCreateOrUpdateAction_564230 = ref object of OpenApiRestCall_563565
proc url_AlertRulesCreateOrUpdateAction_564232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  assert "actionId" in path, "`actionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesCreateOrUpdateAction_564231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564233 = path.getOrDefault("ruleId")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "ruleId", valid_564233
  var valid_564234 = path.getOrDefault("actionId")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "actionId", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "operationalInsightsResourceProvider", valid_564236
  var valid_564237 = path.getOrDefault("resourceGroupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "resourceGroupName", valid_564237
  var valid_564238 = path.getOrDefault("workspaceName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "workspaceName", valid_564238
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564239 = query.getOrDefault("api-version")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564239 != nil:
    section.add "api-version", valid_564239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   action: JObject (required)
  ##         : The action
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564241: Call_AlertRulesCreateOrUpdateAction_564230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the action of alert rule.
  ## 
  let valid = call_564241.validator(path, query, header, formData, body)
  let scheme = call_564241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564241.url(scheme.get, call_564241.host, call_564241.base,
                         call_564241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564241, url, valid)

proc call*(call_564242: Call_AlertRulesCreateOrUpdateAction_564230;
          action: JsonNode; ruleId: string; actionId: string; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesCreateOrUpdateAction
  ## Creates or updates the action of alert rule.
  ##   action: JObject (required)
  ##         : The action
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   actionId: string (required)
  ##           : Action ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564243 = newJObject()
  var query_564244 = newJObject()
  var body_564245 = newJObject()
  if action != nil:
    body_564245 = action
  add(path_564243, "ruleId", newJString(ruleId))
  add(query_564244, "api-version", newJString(apiVersion))
  add(path_564243, "actionId", newJString(actionId))
  add(path_564243, "subscriptionId", newJString(subscriptionId))
  add(path_564243, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564243, "resourceGroupName", newJString(resourceGroupName))
  add(path_564243, "workspaceName", newJString(workspaceName))
  result = call_564242.call(path_564243, query_564244, nil, nil, body_564245)

var alertRulesCreateOrUpdateAction* = Call_AlertRulesCreateOrUpdateAction_564230(
    name: "alertRulesCreateOrUpdateAction", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesCreateOrUpdateAction_564231, base: "",
    url: url_AlertRulesCreateOrUpdateAction_564232, schemes: {Scheme.Https})
type
  Call_AlertRulesGetAction_564216 = ref object of OpenApiRestCall_563565
proc url_AlertRulesGetAction_564218(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  assert "actionId" in path, "`actionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesGetAction_564217(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564219 = path.getOrDefault("ruleId")
  valid_564219 = validateParameter(valid_564219, JString, required = true,
                                 default = nil)
  if valid_564219 != nil:
    section.add "ruleId", valid_564219
  var valid_564220 = path.getOrDefault("actionId")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "actionId", valid_564220
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "operationalInsightsResourceProvider", valid_564222
  var valid_564223 = path.getOrDefault("resourceGroupName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "resourceGroupName", valid_564223
  var valid_564224 = path.getOrDefault("workspaceName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "workspaceName", valid_564224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564225 = query.getOrDefault("api-version")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564225 != nil:
    section.add "api-version", valid_564225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564226: Call_AlertRulesGetAction_564216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the action of alert rule.
  ## 
  let valid = call_564226.validator(path, query, header, formData, body)
  let scheme = call_564226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564226.url(scheme.get, call_564226.host, call_564226.base,
                         call_564226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564226, url, valid)

proc call*(call_564227: Call_AlertRulesGetAction_564216; ruleId: string;
          actionId: string; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesGetAction
  ## Gets the action of alert rule.
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   actionId: string (required)
  ##           : Action ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564228 = newJObject()
  var query_564229 = newJObject()
  add(path_564228, "ruleId", newJString(ruleId))
  add(query_564229, "api-version", newJString(apiVersion))
  add(path_564228, "actionId", newJString(actionId))
  add(path_564228, "subscriptionId", newJString(subscriptionId))
  add(path_564228, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564228, "resourceGroupName", newJString(resourceGroupName))
  add(path_564228, "workspaceName", newJString(workspaceName))
  result = call_564227.call(path_564228, query_564229, nil, nil, nil)

var alertRulesGetAction* = Call_AlertRulesGetAction_564216(
    name: "alertRulesGetAction", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesGetAction_564217, base: "",
    url: url_AlertRulesGetAction_564218, schemes: {Scheme.Https})
type
  Call_AlertRulesDeleteAction_564246 = ref object of OpenApiRestCall_563565
proc url_AlertRulesDeleteAction_564248(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "ruleId" in path, "`ruleId` is a required path parameter"
  assert "actionId" in path, "`actionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/alertRules/"),
               (kind: VariableSegment, value: "ruleId"),
               (kind: ConstantSegment, value: "/actions/"),
               (kind: VariableSegment, value: "actionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AlertRulesDeleteAction_564247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ruleId` field"
  var valid_564249 = path.getOrDefault("ruleId")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "ruleId", valid_564249
  var valid_564250 = path.getOrDefault("actionId")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "actionId", valid_564250
  var valid_564251 = path.getOrDefault("subscriptionId")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "subscriptionId", valid_564251
  var valid_564252 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "operationalInsightsResourceProvider", valid_564252
  var valid_564253 = path.getOrDefault("resourceGroupName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "resourceGroupName", valid_564253
  var valid_564254 = path.getOrDefault("workspaceName")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "workspaceName", valid_564254
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564255 = query.getOrDefault("api-version")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564255 != nil:
    section.add "api-version", valid_564255
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564256: Call_AlertRulesDeleteAction_564246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the action of alert rule.
  ## 
  let valid = call_564256.validator(path, query, header, formData, body)
  let scheme = call_564256.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564256.url(scheme.get, call_564256.host, call_564256.base,
                         call_564256.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564256, url, valid)

proc call*(call_564257: Call_AlertRulesDeleteAction_564246; ruleId: string;
          actionId: string; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesDeleteAction
  ## Delete the action of alert rule.
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   actionId: string (required)
  ##           : Action ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564258 = newJObject()
  var query_564259 = newJObject()
  add(path_564258, "ruleId", newJString(ruleId))
  add(query_564259, "api-version", newJString(apiVersion))
  add(path_564258, "actionId", newJString(actionId))
  add(path_564258, "subscriptionId", newJString(subscriptionId))
  add(path_564258, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564258, "resourceGroupName", newJString(resourceGroupName))
  add(path_564258, "workspaceName", newJString(workspaceName))
  result = call_564257.call(path_564258, query_564259, nil, nil, nil)

var alertRulesDeleteAction* = Call_AlertRulesDeleteAction_564246(
    name: "alertRulesDeleteAction", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesDeleteAction_564247, base: "",
    url: url_AlertRulesDeleteAction_564248, schemes: {Scheme.Https})
type
  Call_BookmarksList_564260 = ref object of OpenApiRestCall_563565
proc url_BookmarksList_564262(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksList_564261(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all bookmarks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564263 = path.getOrDefault("subscriptionId")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "subscriptionId", valid_564263
  var valid_564264 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "operationalInsightsResourceProvider", valid_564264
  var valid_564265 = path.getOrDefault("resourceGroupName")
  valid_564265 = validateParameter(valid_564265, JString, required = true,
                                 default = nil)
  if valid_564265 != nil:
    section.add "resourceGroupName", valid_564265
  var valid_564266 = path.getOrDefault("workspaceName")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "workspaceName", valid_564266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564267 = query.getOrDefault("api-version")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564267 != nil:
    section.add "api-version", valid_564267
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564268: Call_BookmarksList_564260; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all bookmarks.
  ## 
  let valid = call_564268.validator(path, query, header, formData, body)
  let scheme = call_564268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564268.url(scheme.get, call_564268.host, call_564268.base,
                         call_564268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564268, url, valid)

proc call*(call_564269: Call_BookmarksList_564260; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksList
  ## Gets all bookmarks.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564270 = newJObject()
  var query_564271 = newJObject()
  add(query_564271, "api-version", newJString(apiVersion))
  add(path_564270, "subscriptionId", newJString(subscriptionId))
  add(path_564270, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564270, "resourceGroupName", newJString(resourceGroupName))
  add(path_564270, "workspaceName", newJString(workspaceName))
  result = call_564269.call(path_564270, query_564271, nil, nil, nil)

var bookmarksList* = Call_BookmarksList_564260(name: "bookmarksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks",
    validator: validate_BookmarksList_564261, base: "", url: url_BookmarksList_564262,
    schemes: {Scheme.Https})
type
  Call_BookmarksCreateOrUpdate_564285 = ref object of OpenApiRestCall_563565
proc url_BookmarksCreateOrUpdate_564287(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksCreateOrUpdate_564286(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564288 = path.getOrDefault("bookmarkId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "bookmarkId", valid_564288
  var valid_564289 = path.getOrDefault("subscriptionId")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "subscriptionId", valid_564289
  var valid_564290 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = nil)
  if valid_564290 != nil:
    section.add "operationalInsightsResourceProvider", valid_564290
  var valid_564291 = path.getOrDefault("resourceGroupName")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "resourceGroupName", valid_564291
  var valid_564292 = path.getOrDefault("workspaceName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "workspaceName", valid_564292
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564293 = query.getOrDefault("api-version")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564293 != nil:
    section.add "api-version", valid_564293
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   bookmark: JObject (required)
  ##           : The bookmark
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564295: Call_BookmarksCreateOrUpdate_564285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the bookmark.
  ## 
  let valid = call_564295.validator(path, query, header, formData, body)
  let scheme = call_564295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564295.url(scheme.get, call_564295.host, call_564295.base,
                         call_564295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564295, url, valid)

proc call*(call_564296: Call_BookmarksCreateOrUpdate_564285; bookmarkId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; bookmark: JsonNode; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksCreateOrUpdate
  ## Creates or updates the bookmark.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmark: JObject (required)
  ##           : The bookmark
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564297 = newJObject()
  var query_564298 = newJObject()
  var body_564299 = newJObject()
  add(query_564298, "api-version", newJString(apiVersion))
  add(path_564297, "bookmarkId", newJString(bookmarkId))
  add(path_564297, "subscriptionId", newJString(subscriptionId))
  add(path_564297, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564297, "resourceGroupName", newJString(resourceGroupName))
  if bookmark != nil:
    body_564299 = bookmark
  add(path_564297, "workspaceName", newJString(workspaceName))
  result = call_564296.call(path_564297, query_564298, nil, nil, body_564299)

var bookmarksCreateOrUpdate* = Call_BookmarksCreateOrUpdate_564285(
    name: "bookmarksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksCreateOrUpdate_564286, base: "",
    url: url_BookmarksCreateOrUpdate_564287, schemes: {Scheme.Https})
type
  Call_BookmarksGet_564272 = ref object of OpenApiRestCall_563565
proc url_BookmarksGet_564274(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksGet_564273(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564275 = path.getOrDefault("bookmarkId")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "bookmarkId", valid_564275
  var valid_564276 = path.getOrDefault("subscriptionId")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "subscriptionId", valid_564276
  var valid_564277 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "operationalInsightsResourceProvider", valid_564277
  var valid_564278 = path.getOrDefault("resourceGroupName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "resourceGroupName", valid_564278
  var valid_564279 = path.getOrDefault("workspaceName")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = nil)
  if valid_564279 != nil:
    section.add "workspaceName", valid_564279
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564280 = query.getOrDefault("api-version")
  valid_564280 = validateParameter(valid_564280, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564280 != nil:
    section.add "api-version", valid_564280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564281: Call_BookmarksGet_564272; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a bookmark.
  ## 
  let valid = call_564281.validator(path, query, header, formData, body)
  let scheme = call_564281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564281.url(scheme.get, call_564281.host, call_564281.base,
                         call_564281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564281, url, valid)

proc call*(call_564282: Call_BookmarksGet_564272; bookmarkId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksGet
  ## Gets a bookmark.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564283 = newJObject()
  var query_564284 = newJObject()
  add(query_564284, "api-version", newJString(apiVersion))
  add(path_564283, "bookmarkId", newJString(bookmarkId))
  add(path_564283, "subscriptionId", newJString(subscriptionId))
  add(path_564283, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564283, "resourceGroupName", newJString(resourceGroupName))
  add(path_564283, "workspaceName", newJString(workspaceName))
  result = call_564282.call(path_564283, query_564284, nil, nil, nil)

var bookmarksGet* = Call_BookmarksGet_564272(name: "bookmarksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksGet_564273, base: "", url: url_BookmarksGet_564274,
    schemes: {Scheme.Https})
type
  Call_BookmarksDelete_564300 = ref object of OpenApiRestCall_563565
proc url_BookmarksDelete_564302(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarksDelete_564301(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete the bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564303 = path.getOrDefault("bookmarkId")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "bookmarkId", valid_564303
  var valid_564304 = path.getOrDefault("subscriptionId")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "subscriptionId", valid_564304
  var valid_564305 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564305 = validateParameter(valid_564305, JString, required = true,
                                 default = nil)
  if valid_564305 != nil:
    section.add "operationalInsightsResourceProvider", valid_564305
  var valid_564306 = path.getOrDefault("resourceGroupName")
  valid_564306 = validateParameter(valid_564306, JString, required = true,
                                 default = nil)
  if valid_564306 != nil:
    section.add "resourceGroupName", valid_564306
  var valid_564307 = path.getOrDefault("workspaceName")
  valid_564307 = validateParameter(valid_564307, JString, required = true,
                                 default = nil)
  if valid_564307 != nil:
    section.add "workspaceName", valid_564307
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564308 = query.getOrDefault("api-version")
  valid_564308 = validateParameter(valid_564308, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564308 != nil:
    section.add "api-version", valid_564308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564309: Call_BookmarksDelete_564300; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the bookmark.
  ## 
  let valid = call_564309.validator(path, query, header, formData, body)
  let scheme = call_564309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564309.url(scheme.get, call_564309.host, call_564309.base,
                         call_564309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564309, url, valid)

proc call*(call_564310: Call_BookmarksDelete_564300; bookmarkId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksDelete
  ## Delete the bookmark.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564311 = newJObject()
  var query_564312 = newJObject()
  add(query_564312, "api-version", newJString(apiVersion))
  add(path_564311, "bookmarkId", newJString(bookmarkId))
  add(path_564311, "subscriptionId", newJString(subscriptionId))
  add(path_564311, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564311, "resourceGroupName", newJString(resourceGroupName))
  add(path_564311, "workspaceName", newJString(workspaceName))
  result = call_564310.call(path_564311, query_564312, nil, nil, nil)

var bookmarksDelete* = Call_BookmarksDelete_564300(name: "bookmarksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksDelete_564301, base: "", url: url_BookmarksDelete_564302,
    schemes: {Scheme.Https})
type
  Call_BookmarkRelationsList_564313 = ref object of OpenApiRestCall_563565
proc url_BookmarkRelationsList_564315(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsList_564314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all bookmark relations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564317 = path.getOrDefault("bookmarkId")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "bookmarkId", valid_564317
  var valid_564318 = path.getOrDefault("subscriptionId")
  valid_564318 = validateParameter(valid_564318, JString, required = true,
                                 default = nil)
  if valid_564318 != nil:
    section.add "subscriptionId", valid_564318
  var valid_564319 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564319 = validateParameter(valid_564319, JString, required = true,
                                 default = nil)
  if valid_564319 != nil:
    section.add "operationalInsightsResourceProvider", valid_564319
  var valid_564320 = path.getOrDefault("resourceGroupName")
  valid_564320 = validateParameter(valid_564320, JString, required = true,
                                 default = nil)
  if valid_564320 != nil:
    section.add "resourceGroupName", valid_564320
  var valid_564321 = path.getOrDefault("workspaceName")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "workspaceName", valid_564321
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_564322 = query.getOrDefault("$skipToken")
  valid_564322 = validateParameter(valid_564322, JString, required = false,
                                 default = nil)
  if valid_564322 != nil:
    section.add "$skipToken", valid_564322
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564323 = query.getOrDefault("api-version")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564323 != nil:
    section.add "api-version", valid_564323
  var valid_564324 = query.getOrDefault("$top")
  valid_564324 = validateParameter(valid_564324, JInt, required = false, default = nil)
  if valid_564324 != nil:
    section.add "$top", valid_564324
  var valid_564325 = query.getOrDefault("$orderby")
  valid_564325 = validateParameter(valid_564325, JString, required = false,
                                 default = nil)
  if valid_564325 != nil:
    section.add "$orderby", valid_564325
  var valid_564326 = query.getOrDefault("$filter")
  valid_564326 = validateParameter(valid_564326, JString, required = false,
                                 default = nil)
  if valid_564326 != nil:
    section.add "$filter", valid_564326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_BookmarkRelationsList_564313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all bookmark relations.
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_BookmarkRelationsList_564313; bookmarkId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string; SkipToken: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## bookmarkRelationsList
  ## Gets all bookmark relations.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  add(query_564330, "$skipToken", newJString(SkipToken))
  add(query_564330, "api-version", newJString(apiVersion))
  add(query_564330, "$top", newJInt(Top))
  add(path_564329, "bookmarkId", newJString(bookmarkId))
  add(path_564329, "subscriptionId", newJString(subscriptionId))
  add(query_564330, "$orderby", newJString(Orderby))
  add(path_564329, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564329, "resourceGroupName", newJString(resourceGroupName))
  add(query_564330, "$filter", newJString(Filter))
  add(path_564329, "workspaceName", newJString(workspaceName))
  result = call_564328.call(path_564329, query_564330, nil, nil, nil)

var bookmarkRelationsList* = Call_BookmarkRelationsList_564313(
    name: "bookmarkRelationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations",
    validator: validate_BookmarkRelationsList_564314, base: "",
    url: url_BookmarkRelationsList_564315, schemes: {Scheme.Https})
type
  Call_BookmarkRelationsCreateOrUpdateRelation_564345 = ref object of OpenApiRestCall_563565
proc url_BookmarkRelationsCreateOrUpdateRelation_564347(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsCreateOrUpdateRelation_564346(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564348 = path.getOrDefault("bookmarkId")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = nil)
  if valid_564348 != nil:
    section.add "bookmarkId", valid_564348
  var valid_564349 = path.getOrDefault("subscriptionId")
  valid_564349 = validateParameter(valid_564349, JString, required = true,
                                 default = nil)
  if valid_564349 != nil:
    section.add "subscriptionId", valid_564349
  var valid_564350 = path.getOrDefault("relationName")
  valid_564350 = validateParameter(valid_564350, JString, required = true,
                                 default = nil)
  if valid_564350 != nil:
    section.add "relationName", valid_564350
  var valid_564351 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564351 = validateParameter(valid_564351, JString, required = true,
                                 default = nil)
  if valid_564351 != nil:
    section.add "operationalInsightsResourceProvider", valid_564351
  var valid_564352 = path.getOrDefault("resourceGroupName")
  valid_564352 = validateParameter(valid_564352, JString, required = true,
                                 default = nil)
  if valid_564352 != nil:
    section.add "resourceGroupName", valid_564352
  var valid_564353 = path.getOrDefault("workspaceName")
  valid_564353 = validateParameter(valid_564353, JString, required = true,
                                 default = nil)
  if valid_564353 != nil:
    section.add "workspaceName", valid_564353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564354 = query.getOrDefault("api-version")
  valid_564354 = validateParameter(valid_564354, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564354 != nil:
    section.add "api-version", valid_564354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564356: Call_BookmarkRelationsCreateOrUpdateRelation_564345;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the bookmark relation.
  ## 
  let valid = call_564356.validator(path, query, header, formData, body)
  let scheme = call_564356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564356.url(scheme.get, call_564356.host, call_564356.base,
                         call_564356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564356, url, valid)

proc call*(call_564357: Call_BookmarkRelationsCreateOrUpdateRelation_564345;
          bookmarkId: string; subscriptionId: string; relationName: string;
          relationInputModel: JsonNode;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsCreateOrUpdateRelation
  ## Creates the bookmark relation.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564358 = newJObject()
  var query_564359 = newJObject()
  var body_564360 = newJObject()
  add(query_564359, "api-version", newJString(apiVersion))
  add(path_564358, "bookmarkId", newJString(bookmarkId))
  add(path_564358, "subscriptionId", newJString(subscriptionId))
  add(path_564358, "relationName", newJString(relationName))
  if relationInputModel != nil:
    body_564360 = relationInputModel
  add(path_564358, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564358, "resourceGroupName", newJString(resourceGroupName))
  add(path_564358, "workspaceName", newJString(workspaceName))
  result = call_564357.call(path_564358, query_564359, nil, nil, body_564360)

var bookmarkRelationsCreateOrUpdateRelation* = Call_BookmarkRelationsCreateOrUpdateRelation_564345(
    name: "bookmarkRelationsCreateOrUpdateRelation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsCreateOrUpdateRelation_564346, base: "",
    url: url_BookmarkRelationsCreateOrUpdateRelation_564347,
    schemes: {Scheme.Https})
type
  Call_BookmarkRelationsGetRelation_564331 = ref object of OpenApiRestCall_563565
proc url_BookmarkRelationsGetRelation_564333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsGetRelation_564332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564334 = path.getOrDefault("bookmarkId")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "bookmarkId", valid_564334
  var valid_564335 = path.getOrDefault("subscriptionId")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = nil)
  if valid_564335 != nil:
    section.add "subscriptionId", valid_564335
  var valid_564336 = path.getOrDefault("relationName")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = nil)
  if valid_564336 != nil:
    section.add "relationName", valid_564336
  var valid_564337 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564337 = validateParameter(valid_564337, JString, required = true,
                                 default = nil)
  if valid_564337 != nil:
    section.add "operationalInsightsResourceProvider", valid_564337
  var valid_564338 = path.getOrDefault("resourceGroupName")
  valid_564338 = validateParameter(valid_564338, JString, required = true,
                                 default = nil)
  if valid_564338 != nil:
    section.add "resourceGroupName", valid_564338
  var valid_564339 = path.getOrDefault("workspaceName")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = nil)
  if valid_564339 != nil:
    section.add "workspaceName", valid_564339
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564340 = query.getOrDefault("api-version")
  valid_564340 = validateParameter(valid_564340, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564340 != nil:
    section.add "api-version", valid_564340
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564341: Call_BookmarkRelationsGetRelation_564331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a bookmark relation.
  ## 
  let valid = call_564341.validator(path, query, header, formData, body)
  let scheme = call_564341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564341.url(scheme.get, call_564341.host, call_564341.base,
                         call_564341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564341, url, valid)

proc call*(call_564342: Call_BookmarkRelationsGetRelation_564331;
          bookmarkId: string; subscriptionId: string; relationName: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsGetRelation
  ## Gets a bookmark relation.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564343 = newJObject()
  var query_564344 = newJObject()
  add(query_564344, "api-version", newJString(apiVersion))
  add(path_564343, "bookmarkId", newJString(bookmarkId))
  add(path_564343, "subscriptionId", newJString(subscriptionId))
  add(path_564343, "relationName", newJString(relationName))
  add(path_564343, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564343, "resourceGroupName", newJString(resourceGroupName))
  add(path_564343, "workspaceName", newJString(workspaceName))
  result = call_564342.call(path_564343, query_564344, nil, nil, nil)

var bookmarkRelationsGetRelation* = Call_BookmarkRelationsGetRelation_564331(
    name: "bookmarkRelationsGetRelation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsGetRelation_564332, base: "",
    url: url_BookmarkRelationsGetRelation_564333, schemes: {Scheme.Https})
type
  Call_BookmarkRelationsDeleteRelation_564361 = ref object of OpenApiRestCall_563565
proc url_BookmarkRelationsDeleteRelation_564363(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "bookmarkId" in path, "`bookmarkId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/bookmarks/"),
               (kind: VariableSegment, value: "bookmarkId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BookmarkRelationsDeleteRelation_564362(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `bookmarkId` field"
  var valid_564364 = path.getOrDefault("bookmarkId")
  valid_564364 = validateParameter(valid_564364, JString, required = true,
                                 default = nil)
  if valid_564364 != nil:
    section.add "bookmarkId", valid_564364
  var valid_564365 = path.getOrDefault("subscriptionId")
  valid_564365 = validateParameter(valid_564365, JString, required = true,
                                 default = nil)
  if valid_564365 != nil:
    section.add "subscriptionId", valid_564365
  var valid_564366 = path.getOrDefault("relationName")
  valid_564366 = validateParameter(valid_564366, JString, required = true,
                                 default = nil)
  if valid_564366 != nil:
    section.add "relationName", valid_564366
  var valid_564367 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "operationalInsightsResourceProvider", valid_564367
  var valid_564368 = path.getOrDefault("resourceGroupName")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = nil)
  if valid_564368 != nil:
    section.add "resourceGroupName", valid_564368
  var valid_564369 = path.getOrDefault("workspaceName")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "workspaceName", valid_564369
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564370 = query.getOrDefault("api-version")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564370 != nil:
    section.add "api-version", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_BookmarkRelationsDeleteRelation_564361;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the bookmark relation.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_BookmarkRelationsDeleteRelation_564361;
          bookmarkId: string; subscriptionId: string; relationName: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsDeleteRelation
  ## Delete the bookmark relation.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564373 = newJObject()
  var query_564374 = newJObject()
  add(query_564374, "api-version", newJString(apiVersion))
  add(path_564373, "bookmarkId", newJString(bookmarkId))
  add(path_564373, "subscriptionId", newJString(subscriptionId))
  add(path_564373, "relationName", newJString(relationName))
  add(path_564373, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564373, "resourceGroupName", newJString(resourceGroupName))
  add(path_564373, "workspaceName", newJString(workspaceName))
  result = call_564372.call(path_564373, query_564374, nil, nil, nil)

var bookmarkRelationsDeleteRelation* = Call_BookmarkRelationsDeleteRelation_564361(
    name: "bookmarkRelationsDeleteRelation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsDeleteRelation_564362, base: "",
    url: url_BookmarkRelationsDeleteRelation_564363, schemes: {Scheme.Https})
type
  Call_CasesList_564375 = ref object of OpenApiRestCall_563565
proc url_CasesList_564377(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesList_564376(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all cases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564378 = path.getOrDefault("subscriptionId")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "subscriptionId", valid_564378
  var valid_564379 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = nil)
  if valid_564379 != nil:
    section.add "operationalInsightsResourceProvider", valid_564379
  var valid_564380 = path.getOrDefault("resourceGroupName")
  valid_564380 = validateParameter(valid_564380, JString, required = true,
                                 default = nil)
  if valid_564380 != nil:
    section.add "resourceGroupName", valid_564380
  var valid_564381 = path.getOrDefault("workspaceName")
  valid_564381 = validateParameter(valid_564381, JString, required = true,
                                 default = nil)
  if valid_564381 != nil:
    section.add "workspaceName", valid_564381
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_564382 = query.getOrDefault("$skipToken")
  valid_564382 = validateParameter(valid_564382, JString, required = false,
                                 default = nil)
  if valid_564382 != nil:
    section.add "$skipToken", valid_564382
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564383 = query.getOrDefault("api-version")
  valid_564383 = validateParameter(valid_564383, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564383 != nil:
    section.add "api-version", valid_564383
  var valid_564384 = query.getOrDefault("$top")
  valid_564384 = validateParameter(valid_564384, JInt, required = false, default = nil)
  if valid_564384 != nil:
    section.add "$top", valid_564384
  var valid_564385 = query.getOrDefault("$orderby")
  valid_564385 = validateParameter(valid_564385, JString, required = false,
                                 default = nil)
  if valid_564385 != nil:
    section.add "$orderby", valid_564385
  var valid_564386 = query.getOrDefault("$filter")
  valid_564386 = validateParameter(valid_564386, JString, required = false,
                                 default = nil)
  if valid_564386 != nil:
    section.add "$filter", valid_564386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564387: Call_CasesList_564375; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all cases.
  ## 
  let valid = call_564387.validator(path, query, header, formData, body)
  let scheme = call_564387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564387.url(scheme.get, call_564387.host, call_564387.base,
                         call_564387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564387, url, valid)

proc call*(call_564388: Call_CasesList_564375; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; SkipToken: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## casesList
  ## Gets all cases.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564389 = newJObject()
  var query_564390 = newJObject()
  add(query_564390, "$skipToken", newJString(SkipToken))
  add(query_564390, "api-version", newJString(apiVersion))
  add(query_564390, "$top", newJInt(Top))
  add(path_564389, "subscriptionId", newJString(subscriptionId))
  add(query_564390, "$orderby", newJString(Orderby))
  add(path_564389, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564389, "resourceGroupName", newJString(resourceGroupName))
  add(query_564390, "$filter", newJString(Filter))
  add(path_564389, "workspaceName", newJString(workspaceName))
  result = call_564388.call(path_564389, query_564390, nil, nil, nil)

var casesList* = Call_CasesList_564375(name: "casesList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases",
                                    validator: validate_CasesList_564376,
                                    base: "", url: url_CasesList_564377,
                                    schemes: {Scheme.Https})
type
  Call_CasesCreateOrUpdate_564404 = ref object of OpenApiRestCall_563565
proc url_CasesCreateOrUpdate_564406(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesCreateOrUpdate_564405(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or updates the case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564407 = path.getOrDefault("subscriptionId")
  valid_564407 = validateParameter(valid_564407, JString, required = true,
                                 default = nil)
  if valid_564407 != nil:
    section.add "subscriptionId", valid_564407
  var valid_564408 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564408 = validateParameter(valid_564408, JString, required = true,
                                 default = nil)
  if valid_564408 != nil:
    section.add "operationalInsightsResourceProvider", valid_564408
  var valid_564409 = path.getOrDefault("resourceGroupName")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = nil)
  if valid_564409 != nil:
    section.add "resourceGroupName", valid_564409
  var valid_564410 = path.getOrDefault("caseId")
  valid_564410 = validateParameter(valid_564410, JString, required = true,
                                 default = nil)
  if valid_564410 != nil:
    section.add "caseId", valid_564410
  var valid_564411 = path.getOrDefault("workspaceName")
  valid_564411 = validateParameter(valid_564411, JString, required = true,
                                 default = nil)
  if valid_564411 != nil:
    section.add "workspaceName", valid_564411
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564412 = query.getOrDefault("api-version")
  valid_564412 = validateParameter(valid_564412, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564412 != nil:
    section.add "api-version", valid_564412
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   case: JObject (required)
  ##       : The case
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564414: Call_CasesCreateOrUpdate_564404; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the case.
  ## 
  let valid = call_564414.validator(path, query, header, formData, body)
  let scheme = call_564414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564414.url(scheme.get, call_564414.host, call_564414.base,
                         call_564414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564414, url, valid)

proc call*(call_564415: Call_CasesCreateOrUpdate_564404; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; `case`: JsonNode; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesCreateOrUpdate
  ## Creates or updates the case.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   case: JObject (required)
  ##       : The case
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564416 = newJObject()
  var query_564417 = newJObject()
  var body_564418 = newJObject()
  add(query_564417, "api-version", newJString(apiVersion))
  add(path_564416, "subscriptionId", newJString(subscriptionId))
  add(path_564416, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564416, "resourceGroupName", newJString(resourceGroupName))
  add(path_564416, "caseId", newJString(caseId))
  if `case` != nil:
    body_564418 = `case`
  add(path_564416, "workspaceName", newJString(workspaceName))
  result = call_564415.call(path_564416, query_564417, nil, nil, body_564418)

var casesCreateOrUpdate* = Call_CasesCreateOrUpdate_564404(
    name: "casesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
    validator: validate_CasesCreateOrUpdate_564405, base: "",
    url: url_CasesCreateOrUpdate_564406, schemes: {Scheme.Https})
type
  Call_CasesGet_564391 = ref object of OpenApiRestCall_563565
proc url_CasesGet_564393(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesGet_564392(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564394 = path.getOrDefault("subscriptionId")
  valid_564394 = validateParameter(valid_564394, JString, required = true,
                                 default = nil)
  if valid_564394 != nil:
    section.add "subscriptionId", valid_564394
  var valid_564395 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564395 = validateParameter(valid_564395, JString, required = true,
                                 default = nil)
  if valid_564395 != nil:
    section.add "operationalInsightsResourceProvider", valid_564395
  var valid_564396 = path.getOrDefault("resourceGroupName")
  valid_564396 = validateParameter(valid_564396, JString, required = true,
                                 default = nil)
  if valid_564396 != nil:
    section.add "resourceGroupName", valid_564396
  var valid_564397 = path.getOrDefault("caseId")
  valid_564397 = validateParameter(valid_564397, JString, required = true,
                                 default = nil)
  if valid_564397 != nil:
    section.add "caseId", valid_564397
  var valid_564398 = path.getOrDefault("workspaceName")
  valid_564398 = validateParameter(valid_564398, JString, required = true,
                                 default = nil)
  if valid_564398 != nil:
    section.add "workspaceName", valid_564398
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564399 = query.getOrDefault("api-version")
  valid_564399 = validateParameter(valid_564399, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564399 != nil:
    section.add "api-version", valid_564399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564400: Call_CasesGet_564391; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case.
  ## 
  let valid = call_564400.validator(path, query, header, formData, body)
  let scheme = call_564400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564400.url(scheme.get, call_564400.host, call_564400.base,
                         call_564400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564400, url, valid)

proc call*(call_564401: Call_CasesGet_564391; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesGet
  ## Gets a case.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564402 = newJObject()
  var query_564403 = newJObject()
  add(query_564403, "api-version", newJString(apiVersion))
  add(path_564402, "subscriptionId", newJString(subscriptionId))
  add(path_564402, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564402, "resourceGroupName", newJString(resourceGroupName))
  add(path_564402, "caseId", newJString(caseId))
  add(path_564402, "workspaceName", newJString(workspaceName))
  result = call_564401.call(path_564402, query_564403, nil, nil, nil)

var casesGet* = Call_CasesGet_564391(name: "casesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
                                  validator: validate_CasesGet_564392, base: "",
                                  url: url_CasesGet_564393,
                                  schemes: {Scheme.Https})
type
  Call_CasesDelete_564419 = ref object of OpenApiRestCall_563565
proc url_CasesDelete_564421(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesDelete_564420(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564422 = path.getOrDefault("subscriptionId")
  valid_564422 = validateParameter(valid_564422, JString, required = true,
                                 default = nil)
  if valid_564422 != nil:
    section.add "subscriptionId", valid_564422
  var valid_564423 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564423 = validateParameter(valid_564423, JString, required = true,
                                 default = nil)
  if valid_564423 != nil:
    section.add "operationalInsightsResourceProvider", valid_564423
  var valid_564424 = path.getOrDefault("resourceGroupName")
  valid_564424 = validateParameter(valid_564424, JString, required = true,
                                 default = nil)
  if valid_564424 != nil:
    section.add "resourceGroupName", valid_564424
  var valid_564425 = path.getOrDefault("caseId")
  valid_564425 = validateParameter(valid_564425, JString, required = true,
                                 default = nil)
  if valid_564425 != nil:
    section.add "caseId", valid_564425
  var valid_564426 = path.getOrDefault("workspaceName")
  valid_564426 = validateParameter(valid_564426, JString, required = true,
                                 default = nil)
  if valid_564426 != nil:
    section.add "workspaceName", valid_564426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564427 = query.getOrDefault("api-version")
  valid_564427 = validateParameter(valid_564427, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564427 != nil:
    section.add "api-version", valid_564427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564428: Call_CasesDelete_564419; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the case.
  ## 
  let valid = call_564428.validator(path, query, header, formData, body)
  let scheme = call_564428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564428.url(scheme.get, call_564428.host, call_564428.base,
                         call_564428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564428, url, valid)

proc call*(call_564429: Call_CasesDelete_564419; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesDelete
  ## Delete the case.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564430 = newJObject()
  var query_564431 = newJObject()
  add(query_564431, "api-version", newJString(apiVersion))
  add(path_564430, "subscriptionId", newJString(subscriptionId))
  add(path_564430, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564430, "resourceGroupName", newJString(resourceGroupName))
  add(path_564430, "caseId", newJString(caseId))
  add(path_564430, "workspaceName", newJString(workspaceName))
  result = call_564429.call(path_564430, query_564431, nil, nil, nil)

var casesDelete* = Call_CasesDelete_564419(name: "casesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
                                        validator: validate_CasesDelete_564420,
                                        base: "", url: url_CasesDelete_564421,
                                        schemes: {Scheme.Https})
type
  Call_CommentsListByCase_564432 = ref object of OpenApiRestCall_563565
proc url_CommentsListByCase_564434(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/comments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CommentsListByCase_564433(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all case comments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564435 = path.getOrDefault("subscriptionId")
  valid_564435 = validateParameter(valid_564435, JString, required = true,
                                 default = nil)
  if valid_564435 != nil:
    section.add "subscriptionId", valid_564435
  var valid_564436 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564436 = validateParameter(valid_564436, JString, required = true,
                                 default = nil)
  if valid_564436 != nil:
    section.add "operationalInsightsResourceProvider", valid_564436
  var valid_564437 = path.getOrDefault("resourceGroupName")
  valid_564437 = validateParameter(valid_564437, JString, required = true,
                                 default = nil)
  if valid_564437 != nil:
    section.add "resourceGroupName", valid_564437
  var valid_564438 = path.getOrDefault("caseId")
  valid_564438 = validateParameter(valid_564438, JString, required = true,
                                 default = nil)
  if valid_564438 != nil:
    section.add "caseId", valid_564438
  var valid_564439 = path.getOrDefault("workspaceName")
  valid_564439 = validateParameter(valid_564439, JString, required = true,
                                 default = nil)
  if valid_564439 != nil:
    section.add "workspaceName", valid_564439
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_564440 = query.getOrDefault("$skipToken")
  valid_564440 = validateParameter(valid_564440, JString, required = false,
                                 default = nil)
  if valid_564440 != nil:
    section.add "$skipToken", valid_564440
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564441 = query.getOrDefault("api-version")
  valid_564441 = validateParameter(valid_564441, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564441 != nil:
    section.add "api-version", valid_564441
  var valid_564442 = query.getOrDefault("$top")
  valid_564442 = validateParameter(valid_564442, JInt, required = false, default = nil)
  if valid_564442 != nil:
    section.add "$top", valid_564442
  var valid_564443 = query.getOrDefault("$orderby")
  valid_564443 = validateParameter(valid_564443, JString, required = false,
                                 default = nil)
  if valid_564443 != nil:
    section.add "$orderby", valid_564443
  var valid_564444 = query.getOrDefault("$filter")
  valid_564444 = validateParameter(valid_564444, JString, required = false,
                                 default = nil)
  if valid_564444 != nil:
    section.add "$filter", valid_564444
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564445: Call_CommentsListByCase_564432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all case comments.
  ## 
  let valid = call_564445.validator(path, query, header, formData, body)
  let scheme = call_564445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564445.url(scheme.get, call_564445.host, call_564445.base,
                         call_564445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564445, url, valid)

proc call*(call_564446: Call_CommentsListByCase_564432; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string; SkipToken: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## commentsListByCase
  ## Gets all case comments.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564447 = newJObject()
  var query_564448 = newJObject()
  add(query_564448, "$skipToken", newJString(SkipToken))
  add(query_564448, "api-version", newJString(apiVersion))
  add(query_564448, "$top", newJInt(Top))
  add(path_564447, "subscriptionId", newJString(subscriptionId))
  add(query_564448, "$orderby", newJString(Orderby))
  add(path_564447, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564447, "resourceGroupName", newJString(resourceGroupName))
  add(query_564448, "$filter", newJString(Filter))
  add(path_564447, "caseId", newJString(caseId))
  add(path_564447, "workspaceName", newJString(workspaceName))
  result = call_564446.call(path_564447, query_564448, nil, nil, nil)

var commentsListByCase* = Call_CommentsListByCase_564432(
    name: "commentsListByCase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments",
    validator: validate_CommentsListByCase_564433, base: "",
    url: url_CommentsListByCase_564434, schemes: {Scheme.Https})
type
  Call_CaseCommentsCreateComment_564463 = ref object of OpenApiRestCall_563565
proc url_CaseCommentsCreateComment_564465(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "caseCommentId" in path, "`caseCommentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "caseCommentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseCommentsCreateComment_564464(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the case comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   caseCommentId: JString (required)
  ##                : Case comment ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `caseCommentId` field"
  var valid_564466 = path.getOrDefault("caseCommentId")
  valid_564466 = validateParameter(valid_564466, JString, required = true,
                                 default = nil)
  if valid_564466 != nil:
    section.add "caseCommentId", valid_564466
  var valid_564467 = path.getOrDefault("subscriptionId")
  valid_564467 = validateParameter(valid_564467, JString, required = true,
                                 default = nil)
  if valid_564467 != nil:
    section.add "subscriptionId", valid_564467
  var valid_564468 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564468 = validateParameter(valid_564468, JString, required = true,
                                 default = nil)
  if valid_564468 != nil:
    section.add "operationalInsightsResourceProvider", valid_564468
  var valid_564469 = path.getOrDefault("resourceGroupName")
  valid_564469 = validateParameter(valid_564469, JString, required = true,
                                 default = nil)
  if valid_564469 != nil:
    section.add "resourceGroupName", valid_564469
  var valid_564470 = path.getOrDefault("caseId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "caseId", valid_564470
  var valid_564471 = path.getOrDefault("workspaceName")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "workspaceName", valid_564471
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564472 = query.getOrDefault("api-version")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564472 != nil:
    section.add "api-version", valid_564472
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   caseComment: JObject (required)
  ##              : The case comment
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564474: Call_CaseCommentsCreateComment_564463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the case comment.
  ## 
  let valid = call_564474.validator(path, query, header, formData, body)
  let scheme = call_564474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564474.url(scheme.get, call_564474.host, call_564474.base,
                         call_564474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564474, url, valid)

proc call*(call_564475: Call_CaseCommentsCreateComment_564463;
          caseCommentId: string; subscriptionId: string; caseComment: JsonNode;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseCommentsCreateComment
  ## Creates the case comment.
  ##   caseCommentId: string (required)
  ##                : Case comment ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   caseComment: JObject (required)
  ##              : The case comment
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564476 = newJObject()
  var query_564477 = newJObject()
  var body_564478 = newJObject()
  add(path_564476, "caseCommentId", newJString(caseCommentId))
  add(query_564477, "api-version", newJString(apiVersion))
  add(path_564476, "subscriptionId", newJString(subscriptionId))
  if caseComment != nil:
    body_564478 = caseComment
  add(path_564476, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564476, "resourceGroupName", newJString(resourceGroupName))
  add(path_564476, "caseId", newJString(caseId))
  add(path_564476, "workspaceName", newJString(workspaceName))
  result = call_564475.call(path_564476, query_564477, nil, nil, body_564478)

var caseCommentsCreateComment* = Call_CaseCommentsCreateComment_564463(
    name: "caseCommentsCreateComment", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments/{caseCommentId}",
    validator: validate_CaseCommentsCreateComment_564464, base: "",
    url: url_CaseCommentsCreateComment_564465, schemes: {Scheme.Https})
type
  Call_CasesGetComment_564449 = ref object of OpenApiRestCall_563565
proc url_CasesGetComment_564451(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "caseCommentId" in path, "`caseCommentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/comments/"),
               (kind: VariableSegment, value: "caseCommentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CasesGetComment_564450(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a case comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   caseCommentId: JString (required)
  ##                : Case comment ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `caseCommentId` field"
  var valid_564452 = path.getOrDefault("caseCommentId")
  valid_564452 = validateParameter(valid_564452, JString, required = true,
                                 default = nil)
  if valid_564452 != nil:
    section.add "caseCommentId", valid_564452
  var valid_564453 = path.getOrDefault("subscriptionId")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "subscriptionId", valid_564453
  var valid_564454 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = nil)
  if valid_564454 != nil:
    section.add "operationalInsightsResourceProvider", valid_564454
  var valid_564455 = path.getOrDefault("resourceGroupName")
  valid_564455 = validateParameter(valid_564455, JString, required = true,
                                 default = nil)
  if valid_564455 != nil:
    section.add "resourceGroupName", valid_564455
  var valid_564456 = path.getOrDefault("caseId")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "caseId", valid_564456
  var valid_564457 = path.getOrDefault("workspaceName")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "workspaceName", valid_564457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564458 = query.getOrDefault("api-version")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564458 != nil:
    section.add "api-version", valid_564458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564459: Call_CasesGetComment_564449; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case comment.
  ## 
  let valid = call_564459.validator(path, query, header, formData, body)
  let scheme = call_564459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564459.url(scheme.get, call_564459.host, call_564459.base,
                         call_564459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564459, url, valid)

proc call*(call_564460: Call_CasesGetComment_564449; caseCommentId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesGetComment
  ## Gets a case comment.
  ##   caseCommentId: string (required)
  ##                : Case comment ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564461 = newJObject()
  var query_564462 = newJObject()
  add(path_564461, "caseCommentId", newJString(caseCommentId))
  add(query_564462, "api-version", newJString(apiVersion))
  add(path_564461, "subscriptionId", newJString(subscriptionId))
  add(path_564461, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564461, "resourceGroupName", newJString(resourceGroupName))
  add(path_564461, "caseId", newJString(caseId))
  add(path_564461, "workspaceName", newJString(workspaceName))
  result = call_564460.call(path_564461, query_564462, nil, nil, nil)

var casesGetComment* = Call_CasesGetComment_564449(name: "casesGetComment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments/{caseCommentId}",
    validator: validate_CasesGetComment_564450, base: "", url: url_CasesGetComment_564451,
    schemes: {Scheme.Https})
type
  Call_CaseRelationsList_564479 = ref object of OpenApiRestCall_563565
proc url_CaseRelationsList_564481(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsList_564480(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all case relations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564482 = path.getOrDefault("subscriptionId")
  valid_564482 = validateParameter(valid_564482, JString, required = true,
                                 default = nil)
  if valid_564482 != nil:
    section.add "subscriptionId", valid_564482
  var valid_564483 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564483 = validateParameter(valid_564483, JString, required = true,
                                 default = nil)
  if valid_564483 != nil:
    section.add "operationalInsightsResourceProvider", valid_564483
  var valid_564484 = path.getOrDefault("resourceGroupName")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "resourceGroupName", valid_564484
  var valid_564485 = path.getOrDefault("caseId")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "caseId", valid_564485
  var valid_564486 = path.getOrDefault("workspaceName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "workspaceName", valid_564486
  result.add "path", section
  ## parameters in `query` object:
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_564487 = query.getOrDefault("$skipToken")
  valid_564487 = validateParameter(valid_564487, JString, required = false,
                                 default = nil)
  if valid_564487 != nil:
    section.add "$skipToken", valid_564487
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564488 = query.getOrDefault("api-version")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564488 != nil:
    section.add "api-version", valid_564488
  var valid_564489 = query.getOrDefault("$top")
  valid_564489 = validateParameter(valid_564489, JInt, required = false, default = nil)
  if valid_564489 != nil:
    section.add "$top", valid_564489
  var valid_564490 = query.getOrDefault("$orderby")
  valid_564490 = validateParameter(valid_564490, JString, required = false,
                                 default = nil)
  if valid_564490 != nil:
    section.add "$orderby", valid_564490
  var valid_564491 = query.getOrDefault("$filter")
  valid_564491 = validateParameter(valid_564491, JString, required = false,
                                 default = nil)
  if valid_564491 != nil:
    section.add "$filter", valid_564491
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564492: Call_CaseRelationsList_564479; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all case relations.
  ## 
  let valid = call_564492.validator(path, query, header, formData, body)
  let scheme = call_564492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564492.url(scheme.get, call_564492.host, call_564492.base,
                         call_564492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564492, url, valid)

proc call*(call_564493: Call_CaseRelationsList_564479; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string; SkipToken: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0; Orderby: string = "";
          Filter: string = ""): Recallable =
  ## caseRelationsList
  ## Gets all case relations.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564494 = newJObject()
  var query_564495 = newJObject()
  add(query_564495, "$skipToken", newJString(SkipToken))
  add(query_564495, "api-version", newJString(apiVersion))
  add(query_564495, "$top", newJInt(Top))
  add(path_564494, "subscriptionId", newJString(subscriptionId))
  add(query_564495, "$orderby", newJString(Orderby))
  add(path_564494, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564494, "resourceGroupName", newJString(resourceGroupName))
  add(query_564495, "$filter", newJString(Filter))
  add(path_564494, "caseId", newJString(caseId))
  add(path_564494, "workspaceName", newJString(workspaceName))
  result = call_564493.call(path_564494, query_564495, nil, nil, nil)

var caseRelationsList* = Call_CaseRelationsList_564479(name: "caseRelationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations",
    validator: validate_CaseRelationsList_564480, base: "",
    url: url_CaseRelationsList_564481, schemes: {Scheme.Https})
type
  Call_CaseRelationsCreateOrUpdateRelation_564510 = ref object of OpenApiRestCall_563565
proc url_CaseRelationsCreateOrUpdateRelation_564512(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsCreateOrUpdateRelation_564511(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564513 = path.getOrDefault("subscriptionId")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "subscriptionId", valid_564513
  var valid_564514 = path.getOrDefault("relationName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "relationName", valid_564514
  var valid_564515 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "operationalInsightsResourceProvider", valid_564515
  var valid_564516 = path.getOrDefault("resourceGroupName")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "resourceGroupName", valid_564516
  var valid_564517 = path.getOrDefault("caseId")
  valid_564517 = validateParameter(valid_564517, JString, required = true,
                                 default = nil)
  if valid_564517 != nil:
    section.add "caseId", valid_564517
  var valid_564518 = path.getOrDefault("workspaceName")
  valid_564518 = validateParameter(valid_564518, JString, required = true,
                                 default = nil)
  if valid_564518 != nil:
    section.add "workspaceName", valid_564518
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564519 = query.getOrDefault("api-version")
  valid_564519 = validateParameter(valid_564519, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564519 != nil:
    section.add "api-version", valid_564519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564521: Call_CaseRelationsCreateOrUpdateRelation_564510;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the case relation.
  ## 
  let valid = call_564521.validator(path, query, header, formData, body)
  let scheme = call_564521.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564521.url(scheme.get, call_564521.host, call_564521.base,
                         call_564521.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564521, url, valid)

proc call*(call_564522: Call_CaseRelationsCreateOrUpdateRelation_564510;
          subscriptionId: string; relationName: string;
          relationInputModel: JsonNode;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsCreateOrUpdateRelation
  ## Creates or updates the case relation.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564523 = newJObject()
  var query_564524 = newJObject()
  var body_564525 = newJObject()
  add(query_564524, "api-version", newJString(apiVersion))
  add(path_564523, "subscriptionId", newJString(subscriptionId))
  add(path_564523, "relationName", newJString(relationName))
  if relationInputModel != nil:
    body_564525 = relationInputModel
  add(path_564523, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564523, "resourceGroupName", newJString(resourceGroupName))
  add(path_564523, "caseId", newJString(caseId))
  add(path_564523, "workspaceName", newJString(workspaceName))
  result = call_564522.call(path_564523, query_564524, nil, nil, body_564525)

var caseRelationsCreateOrUpdateRelation* = Call_CaseRelationsCreateOrUpdateRelation_564510(
    name: "caseRelationsCreateOrUpdateRelation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsCreateOrUpdateRelation_564511, base: "",
    url: url_CaseRelationsCreateOrUpdateRelation_564512, schemes: {Scheme.Https})
type
  Call_CaseRelationsGetRelation_564496 = ref object of OpenApiRestCall_563565
proc url_CaseRelationsGetRelation_564498(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsGetRelation_564497(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564499 = path.getOrDefault("subscriptionId")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "subscriptionId", valid_564499
  var valid_564500 = path.getOrDefault("relationName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "relationName", valid_564500
  var valid_564501 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "operationalInsightsResourceProvider", valid_564501
  var valid_564502 = path.getOrDefault("resourceGroupName")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "resourceGroupName", valid_564502
  var valid_564503 = path.getOrDefault("caseId")
  valid_564503 = validateParameter(valid_564503, JString, required = true,
                                 default = nil)
  if valid_564503 != nil:
    section.add "caseId", valid_564503
  var valid_564504 = path.getOrDefault("workspaceName")
  valid_564504 = validateParameter(valid_564504, JString, required = true,
                                 default = nil)
  if valid_564504 != nil:
    section.add "workspaceName", valid_564504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564505 = query.getOrDefault("api-version")
  valid_564505 = validateParameter(valid_564505, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564505 != nil:
    section.add "api-version", valid_564505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564506: Call_CaseRelationsGetRelation_564496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case relation.
  ## 
  let valid = call_564506.validator(path, query, header, formData, body)
  let scheme = call_564506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564506.url(scheme.get, call_564506.host, call_564506.base,
                         call_564506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564506, url, valid)

proc call*(call_564507: Call_CaseRelationsGetRelation_564496;
          subscriptionId: string; relationName: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsGetRelation
  ## Gets a case relation.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564508 = newJObject()
  var query_564509 = newJObject()
  add(query_564509, "api-version", newJString(apiVersion))
  add(path_564508, "subscriptionId", newJString(subscriptionId))
  add(path_564508, "relationName", newJString(relationName))
  add(path_564508, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564508, "resourceGroupName", newJString(resourceGroupName))
  add(path_564508, "caseId", newJString(caseId))
  add(path_564508, "workspaceName", newJString(workspaceName))
  result = call_564507.call(path_564508, query_564509, nil, nil, nil)

var caseRelationsGetRelation* = Call_CaseRelationsGetRelation_564496(
    name: "caseRelationsGetRelation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsGetRelation_564497, base: "",
    url: url_CaseRelationsGetRelation_564498, schemes: {Scheme.Https})
type
  Call_CaseRelationsDeleteRelation_564526 = ref object of OpenApiRestCall_563565
proc url_CaseRelationsDeleteRelation_564528(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "caseId" in path, "`caseId` is a required path parameter"
  assert "relationName" in path, "`relationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/cases/"),
               (kind: VariableSegment, value: "caseId"),
               (kind: ConstantSegment, value: "/relations/"),
               (kind: VariableSegment, value: "relationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CaseRelationsDeleteRelation_564527(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564529 = path.getOrDefault("subscriptionId")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "subscriptionId", valid_564529
  var valid_564530 = path.getOrDefault("relationName")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "relationName", valid_564530
  var valid_564531 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = nil)
  if valid_564531 != nil:
    section.add "operationalInsightsResourceProvider", valid_564531
  var valid_564532 = path.getOrDefault("resourceGroupName")
  valid_564532 = validateParameter(valid_564532, JString, required = true,
                                 default = nil)
  if valid_564532 != nil:
    section.add "resourceGroupName", valid_564532
  var valid_564533 = path.getOrDefault("caseId")
  valid_564533 = validateParameter(valid_564533, JString, required = true,
                                 default = nil)
  if valid_564533 != nil:
    section.add "caseId", valid_564533
  var valid_564534 = path.getOrDefault("workspaceName")
  valid_564534 = validateParameter(valid_564534, JString, required = true,
                                 default = nil)
  if valid_564534 != nil:
    section.add "workspaceName", valid_564534
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564535 = query.getOrDefault("api-version")
  valid_564535 = validateParameter(valid_564535, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564535 != nil:
    section.add "api-version", valid_564535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564536: Call_CaseRelationsDeleteRelation_564526; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the case relation.
  ## 
  let valid = call_564536.validator(path, query, header, formData, body)
  let scheme = call_564536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564536.url(scheme.get, call_564536.host, call_564536.base,
                         call_564536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564536, url, valid)

proc call*(call_564537: Call_CaseRelationsDeleteRelation_564526;
          subscriptionId: string; relationName: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          caseId: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsDeleteRelation
  ## Delete the case relation.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: string (required)
  ##         : Case ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564538 = newJObject()
  var query_564539 = newJObject()
  add(query_564539, "api-version", newJString(apiVersion))
  add(path_564538, "subscriptionId", newJString(subscriptionId))
  add(path_564538, "relationName", newJString(relationName))
  add(path_564538, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564538, "resourceGroupName", newJString(resourceGroupName))
  add(path_564538, "caseId", newJString(caseId))
  add(path_564538, "workspaceName", newJString(workspaceName))
  result = call_564537.call(path_564538, query_564539, nil, nil, nil)

var caseRelationsDeleteRelation* = Call_CaseRelationsDeleteRelation_564526(
    name: "caseRelationsDeleteRelation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsDeleteRelation_564527, base: "",
    url: url_CaseRelationsDeleteRelation_564528, schemes: {Scheme.Https})
type
  Call_DataConnectorsList_564540 = ref object of OpenApiRestCall_563565
proc url_DataConnectorsList_564542(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsList_564541(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all data connectors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564543 = path.getOrDefault("subscriptionId")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "subscriptionId", valid_564543
  var valid_564544 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "operationalInsightsResourceProvider", valid_564544
  var valid_564545 = path.getOrDefault("resourceGroupName")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "resourceGroupName", valid_564545
  var valid_564546 = path.getOrDefault("workspaceName")
  valid_564546 = validateParameter(valid_564546, JString, required = true,
                                 default = nil)
  if valid_564546 != nil:
    section.add "workspaceName", valid_564546
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564547 = query.getOrDefault("api-version")
  valid_564547 = validateParameter(valid_564547, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564547 != nil:
    section.add "api-version", valid_564547
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564548: Call_DataConnectorsList_564540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all data connectors.
  ## 
  let valid = call_564548.validator(path, query, header, formData, body)
  let scheme = call_564548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564548.url(scheme.get, call_564548.host, call_564548.base,
                         call_564548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564548, url, valid)

proc call*(call_564549: Call_DataConnectorsList_564540; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsList
  ## Gets all data connectors.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564550 = newJObject()
  var query_564551 = newJObject()
  add(query_564551, "api-version", newJString(apiVersion))
  add(path_564550, "subscriptionId", newJString(subscriptionId))
  add(path_564550, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564550, "resourceGroupName", newJString(resourceGroupName))
  add(path_564550, "workspaceName", newJString(workspaceName))
  result = call_564549.call(path_564550, query_564551, nil, nil, nil)

var dataConnectorsList* = Call_DataConnectorsList_564540(
    name: "dataConnectorsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors",
    validator: validate_DataConnectorsList_564541, base: "",
    url: url_DataConnectorsList_564542, schemes: {Scheme.Https})
type
  Call_DataConnectorsCreateOrUpdate_564565 = ref object of OpenApiRestCall_563565
proc url_DataConnectorsCreateOrUpdate_564567(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "dataConnectorId" in path, "`dataConnectorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors/"),
               (kind: VariableSegment, value: "dataConnectorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsCreateOrUpdate_564566(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataConnectorId` field"
  var valid_564568 = path.getOrDefault("dataConnectorId")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "dataConnectorId", valid_564568
  var valid_564569 = path.getOrDefault("subscriptionId")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "subscriptionId", valid_564569
  var valid_564570 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "operationalInsightsResourceProvider", valid_564570
  var valid_564571 = path.getOrDefault("resourceGroupName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "resourceGroupName", valid_564571
  var valid_564572 = path.getOrDefault("workspaceName")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "workspaceName", valid_564572
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564573 = query.getOrDefault("api-version")
  valid_564573 = validateParameter(valid_564573, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564573 != nil:
    section.add "api-version", valid_564573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   dataConnector: JObject (required)
  ##                : The data connector
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_DataConnectorsCreateOrUpdate_564565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the data connector.
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_DataConnectorsCreateOrUpdate_564565;
          dataConnectorId: string; dataConnector: JsonNode; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsCreateOrUpdate
  ## Creates or updates the data connector.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   dataConnector: JObject (required)
  ##                : The data connector
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564577 = newJObject()
  var query_564578 = newJObject()
  var body_564579 = newJObject()
  add(path_564577, "dataConnectorId", newJString(dataConnectorId))
  add(query_564578, "api-version", newJString(apiVersion))
  if dataConnector != nil:
    body_564579 = dataConnector
  add(path_564577, "subscriptionId", newJString(subscriptionId))
  add(path_564577, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564577, "resourceGroupName", newJString(resourceGroupName))
  add(path_564577, "workspaceName", newJString(workspaceName))
  result = call_564576.call(path_564577, query_564578, nil, nil, body_564579)

var dataConnectorsCreateOrUpdate* = Call_DataConnectorsCreateOrUpdate_564565(
    name: "dataConnectorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsCreateOrUpdate_564566, base: "",
    url: url_DataConnectorsCreateOrUpdate_564567, schemes: {Scheme.Https})
type
  Call_DataConnectorsGet_564552 = ref object of OpenApiRestCall_563565
proc url_DataConnectorsGet_564554(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "dataConnectorId" in path, "`dataConnectorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors/"),
               (kind: VariableSegment, value: "dataConnectorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsGet_564553(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataConnectorId` field"
  var valid_564555 = path.getOrDefault("dataConnectorId")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "dataConnectorId", valid_564555
  var valid_564556 = path.getOrDefault("subscriptionId")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "subscriptionId", valid_564556
  var valid_564557 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "operationalInsightsResourceProvider", valid_564557
  var valid_564558 = path.getOrDefault("resourceGroupName")
  valid_564558 = validateParameter(valid_564558, JString, required = true,
                                 default = nil)
  if valid_564558 != nil:
    section.add "resourceGroupName", valid_564558
  var valid_564559 = path.getOrDefault("workspaceName")
  valid_564559 = validateParameter(valid_564559, JString, required = true,
                                 default = nil)
  if valid_564559 != nil:
    section.add "workspaceName", valid_564559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564560 = query.getOrDefault("api-version")
  valid_564560 = validateParameter(valid_564560, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564560 != nil:
    section.add "api-version", valid_564560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564561: Call_DataConnectorsGet_564552; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a data connector.
  ## 
  let valid = call_564561.validator(path, query, header, formData, body)
  let scheme = call_564561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564561.url(scheme.get, call_564561.host, call_564561.base,
                         call_564561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564561, url, valid)

proc call*(call_564562: Call_DataConnectorsGet_564552; dataConnectorId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsGet
  ## Gets a data connector.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564563 = newJObject()
  var query_564564 = newJObject()
  add(path_564563, "dataConnectorId", newJString(dataConnectorId))
  add(query_564564, "api-version", newJString(apiVersion))
  add(path_564563, "subscriptionId", newJString(subscriptionId))
  add(path_564563, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564563, "resourceGroupName", newJString(resourceGroupName))
  add(path_564563, "workspaceName", newJString(workspaceName))
  result = call_564562.call(path_564563, query_564564, nil, nil, nil)

var dataConnectorsGet* = Call_DataConnectorsGet_564552(name: "dataConnectorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsGet_564553, base: "",
    url: url_DataConnectorsGet_564554, schemes: {Scheme.Https})
type
  Call_DataConnectorsDelete_564580 = ref object of OpenApiRestCall_563565
proc url_DataConnectorsDelete_564582(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "dataConnectorId" in path, "`dataConnectorId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/dataConnectors/"),
               (kind: VariableSegment, value: "dataConnectorId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataConnectorsDelete_564581(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `dataConnectorId` field"
  var valid_564583 = path.getOrDefault("dataConnectorId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "dataConnectorId", valid_564583
  var valid_564584 = path.getOrDefault("subscriptionId")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "subscriptionId", valid_564584
  var valid_564585 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "operationalInsightsResourceProvider", valid_564585
  var valid_564586 = path.getOrDefault("resourceGroupName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "resourceGroupName", valid_564586
  var valid_564587 = path.getOrDefault("workspaceName")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "workspaceName", valid_564587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564588 = query.getOrDefault("api-version")
  valid_564588 = validateParameter(valid_564588, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564588 != nil:
    section.add "api-version", valid_564588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564589: Call_DataConnectorsDelete_564580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the data connector.
  ## 
  let valid = call_564589.validator(path, query, header, formData, body)
  let scheme = call_564589.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564589.url(scheme.get, call_564589.host, call_564589.base,
                         call_564589.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564589, url, valid)

proc call*(call_564590: Call_DataConnectorsDelete_564580; dataConnectorId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsDelete
  ## Delete the data connector.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564591 = newJObject()
  var query_564592 = newJObject()
  add(path_564591, "dataConnectorId", newJString(dataConnectorId))
  add(query_564592, "api-version", newJString(apiVersion))
  add(path_564591, "subscriptionId", newJString(subscriptionId))
  add(path_564591, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564591, "resourceGroupName", newJString(resourceGroupName))
  add(path_564591, "workspaceName", newJString(workspaceName))
  result = call_564590.call(path_564591, query_564592, nil, nil, nil)

var dataConnectorsDelete* = Call_DataConnectorsDelete_564580(
    name: "dataConnectorsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsDelete_564581, base: "",
    url: url_DataConnectorsDelete_564582, schemes: {Scheme.Https})
type
  Call_EntitiesList_564593 = ref object of OpenApiRestCall_563565
proc url_EntitiesList_564595(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntitiesList_564594(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all entities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564596 = path.getOrDefault("subscriptionId")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "subscriptionId", valid_564596
  var valid_564597 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "operationalInsightsResourceProvider", valid_564597
  var valid_564598 = path.getOrDefault("resourceGroupName")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "resourceGroupName", valid_564598
  var valid_564599 = path.getOrDefault("workspaceName")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "workspaceName", valid_564599
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564600 = query.getOrDefault("api-version")
  valid_564600 = validateParameter(valid_564600, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564600 != nil:
    section.add "api-version", valid_564600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564601: Call_EntitiesList_564593; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all entities.
  ## 
  let valid = call_564601.validator(path, query, header, formData, body)
  let scheme = call_564601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564601.url(scheme.get, call_564601.host, call_564601.base,
                         call_564601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564601, url, valid)

proc call*(call_564602: Call_EntitiesList_564593; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesList
  ## Gets all entities.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564603 = newJObject()
  var query_564604 = newJObject()
  add(query_564604, "api-version", newJString(apiVersion))
  add(path_564603, "subscriptionId", newJString(subscriptionId))
  add(path_564603, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564603, "resourceGroupName", newJString(resourceGroupName))
  add(path_564603, "workspaceName", newJString(workspaceName))
  result = call_564602.call(path_564603, query_564604, nil, nil, nil)

var entitiesList* = Call_EntitiesList_564593(name: "entitiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities",
    validator: validate_EntitiesList_564594, base: "", url: url_EntitiesList_564595,
    schemes: {Scheme.Https})
type
  Call_EntitiesGet_564605 = ref object of OpenApiRestCall_563565
proc url_EntitiesGet_564607(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entities/"),
               (kind: VariableSegment, value: "entityId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntitiesGet_564606(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564608 = path.getOrDefault("entityId")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "entityId", valid_564608
  var valid_564609 = path.getOrDefault("subscriptionId")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "subscriptionId", valid_564609
  var valid_564610 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "operationalInsightsResourceProvider", valid_564610
  var valid_564611 = path.getOrDefault("resourceGroupName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "resourceGroupName", valid_564611
  var valid_564612 = path.getOrDefault("workspaceName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "workspaceName", valid_564612
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564613 = query.getOrDefault("api-version")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564613 != nil:
    section.add "api-version", valid_564613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564614: Call_EntitiesGet_564605; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an entity.
  ## 
  let valid = call_564614.validator(path, query, header, formData, body)
  let scheme = call_564614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564614.url(scheme.get, call_564614.host, call_564614.base,
                         call_564614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564614, url, valid)

proc call*(call_564615: Call_EntitiesGet_564605; entityId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesGet
  ## Gets an entity.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityId: string (required)
  ##           : entity ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564616 = newJObject()
  var query_564617 = newJObject()
  add(query_564617, "api-version", newJString(apiVersion))
  add(path_564616, "entityId", newJString(entityId))
  add(path_564616, "subscriptionId", newJString(subscriptionId))
  add(path_564616, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564616, "resourceGroupName", newJString(resourceGroupName))
  add(path_564616, "workspaceName", newJString(workspaceName))
  result = call_564615.call(path_564616, query_564617, nil, nil, nil)

var entitiesGet* = Call_EntitiesGet_564605(name: "entitiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities/{entityId}",
                                        validator: validate_EntitiesGet_564606,
                                        base: "", url: url_EntitiesGet_564607,
                                        schemes: {Scheme.Https})
type
  Call_EntitiesExpand_564618 = ref object of OpenApiRestCall_563565
proc url_EntitiesExpand_564620(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "entityId" in path, "`entityId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entities/"),
               (kind: VariableSegment, value: "entityId"),
               (kind: ConstantSegment, value: "/expand")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntitiesExpand_564619(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Expands an entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityId: JString (required)
  ##           : entity ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `entityId` field"
  var valid_564638 = path.getOrDefault("entityId")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "entityId", valid_564638
  var valid_564639 = path.getOrDefault("subscriptionId")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "subscriptionId", valid_564639
  var valid_564640 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "operationalInsightsResourceProvider", valid_564640
  var valid_564641 = path.getOrDefault("resourceGroupName")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "resourceGroupName", valid_564641
  var valid_564642 = path.getOrDefault("workspaceName")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "workspaceName", valid_564642
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564643 = query.getOrDefault("api-version")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564643 != nil:
    section.add "api-version", valid_564643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters required to execute an expand operation on the given entity.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564645: Call_EntitiesExpand_564618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expands an entity.
  ## 
  let valid = call_564645.validator(path, query, header, formData, body)
  let scheme = call_564645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564645.url(scheme.get, call_564645.host, call_564645.base,
                         call_564645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564645, url, valid)

proc call*(call_564646: Call_EntitiesExpand_564618; entityId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string; parameters: JsonNode;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesExpand
  ## Expands an entity.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityId: string (required)
  ##           : entity ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   parameters: JObject (required)
  ##             : The parameters required to execute an expand operation on the given entity.
  var path_564647 = newJObject()
  var query_564648 = newJObject()
  var body_564649 = newJObject()
  add(query_564648, "api-version", newJString(apiVersion))
  add(path_564647, "entityId", newJString(entityId))
  add(path_564647, "subscriptionId", newJString(subscriptionId))
  add(path_564647, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564647, "resourceGroupName", newJString(resourceGroupName))
  add(path_564647, "workspaceName", newJString(workspaceName))
  if parameters != nil:
    body_564649 = parameters
  result = call_564646.call(path_564647, query_564648, nil, nil, body_564649)

var entitiesExpand* = Call_EntitiesExpand_564618(name: "entitiesExpand",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities/{entityId}/expand",
    validator: validate_EntitiesExpand_564619, base: "", url: url_EntitiesExpand_564620,
    schemes: {Scheme.Https})
type
  Call_EntityQueriesList_564650 = ref object of OpenApiRestCall_563565
proc url_EntityQueriesList_564652(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entityQueries")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntityQueriesList_564651(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all entity queries.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564653 = path.getOrDefault("subscriptionId")
  valid_564653 = validateParameter(valid_564653, JString, required = true,
                                 default = nil)
  if valid_564653 != nil:
    section.add "subscriptionId", valid_564653
  var valid_564654 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564654 = validateParameter(valid_564654, JString, required = true,
                                 default = nil)
  if valid_564654 != nil:
    section.add "operationalInsightsResourceProvider", valid_564654
  var valid_564655 = path.getOrDefault("resourceGroupName")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "resourceGroupName", valid_564655
  var valid_564656 = path.getOrDefault("workspaceName")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "workspaceName", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564657 = query.getOrDefault("api-version")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564657 != nil:
    section.add "api-version", valid_564657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564658: Call_EntityQueriesList_564650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all entity queries.
  ## 
  let valid = call_564658.validator(path, query, header, formData, body)
  let scheme = call_564658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564658.url(scheme.get, call_564658.host, call_564658.base,
                         call_564658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564658, url, valid)

proc call*(call_564659: Call_EntityQueriesList_564650; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entityQueriesList
  ## Gets all entity queries.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564660 = newJObject()
  var query_564661 = newJObject()
  add(query_564661, "api-version", newJString(apiVersion))
  add(path_564660, "subscriptionId", newJString(subscriptionId))
  add(path_564660, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564660, "resourceGroupName", newJString(resourceGroupName))
  add(path_564660, "workspaceName", newJString(workspaceName))
  result = call_564659.call(path_564660, query_564661, nil, nil, nil)

var entityQueriesList* = Call_EntityQueriesList_564650(name: "entityQueriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entityQueries",
    validator: validate_EntityQueriesList_564651, base: "",
    url: url_EntityQueriesList_564652, schemes: {Scheme.Https})
type
  Call_EntityQueriesGet_564662 = ref object of OpenApiRestCall_563565
proc url_EntityQueriesGet_564664(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "entityQueryId" in path, "`entityQueryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/entityQueries/"),
               (kind: VariableSegment, value: "entityQueryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EntityQueriesGet_564663(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an entity query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   entityQueryId: JString (required)
  ##                : entity query ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `entityQueryId` field"
  var valid_564665 = path.getOrDefault("entityQueryId")
  valid_564665 = validateParameter(valid_564665, JString, required = true,
                                 default = nil)
  if valid_564665 != nil:
    section.add "entityQueryId", valid_564665
  var valid_564666 = path.getOrDefault("subscriptionId")
  valid_564666 = validateParameter(valid_564666, JString, required = true,
                                 default = nil)
  if valid_564666 != nil:
    section.add "subscriptionId", valid_564666
  var valid_564667 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564667 = validateParameter(valid_564667, JString, required = true,
                                 default = nil)
  if valid_564667 != nil:
    section.add "operationalInsightsResourceProvider", valid_564667
  var valid_564668 = path.getOrDefault("resourceGroupName")
  valid_564668 = validateParameter(valid_564668, JString, required = true,
                                 default = nil)
  if valid_564668 != nil:
    section.add "resourceGroupName", valid_564668
  var valid_564669 = path.getOrDefault("workspaceName")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "workspaceName", valid_564669
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564670 = query.getOrDefault("api-version")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564670 != nil:
    section.add "api-version", valid_564670
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564671: Call_EntityQueriesGet_564662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an entity query.
  ## 
  let valid = call_564671.validator(path, query, header, formData, body)
  let scheme = call_564671.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564671.url(scheme.get, call_564671.host, call_564671.base,
                         call_564671.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564671, url, valid)

proc call*(call_564672: Call_EntityQueriesGet_564662; entityQueryId: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entityQueriesGet
  ## Gets an entity query.
  ##   entityQueryId: string (required)
  ##                : entity query ID
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564673 = newJObject()
  var query_564674 = newJObject()
  add(path_564673, "entityQueryId", newJString(entityQueryId))
  add(query_564674, "api-version", newJString(apiVersion))
  add(path_564673, "subscriptionId", newJString(subscriptionId))
  add(path_564673, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564673, "resourceGroupName", newJString(resourceGroupName))
  add(path_564673, "workspaceName", newJString(workspaceName))
  result = call_564672.call(path_564673, query_564674, nil, nil, nil)

var entityQueriesGet* = Call_EntityQueriesGet_564662(name: "entityQueriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entityQueries/{entityQueryId}",
    validator: validate_EntityQueriesGet_564663, base: "",
    url: url_EntityQueriesGet_564664, schemes: {Scheme.Https})
type
  Call_OfficeConsentsList_564675 = ref object of OpenApiRestCall_563565
proc url_OfficeConsentsList_564677(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/officeConsents")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfficeConsentsList_564676(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all office365 consents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564678 = path.getOrDefault("subscriptionId")
  valid_564678 = validateParameter(valid_564678, JString, required = true,
                                 default = nil)
  if valid_564678 != nil:
    section.add "subscriptionId", valid_564678
  var valid_564679 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564679 = validateParameter(valid_564679, JString, required = true,
                                 default = nil)
  if valid_564679 != nil:
    section.add "operationalInsightsResourceProvider", valid_564679
  var valid_564680 = path.getOrDefault("resourceGroupName")
  valid_564680 = validateParameter(valid_564680, JString, required = true,
                                 default = nil)
  if valid_564680 != nil:
    section.add "resourceGroupName", valid_564680
  var valid_564681 = path.getOrDefault("workspaceName")
  valid_564681 = validateParameter(valid_564681, JString, required = true,
                                 default = nil)
  if valid_564681 != nil:
    section.add "workspaceName", valid_564681
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564682 = query.getOrDefault("api-version")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564682 != nil:
    section.add "api-version", valid_564682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564683: Call_OfficeConsentsList_564675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all office365 consents.
  ## 
  let valid = call_564683.validator(path, query, header, formData, body)
  let scheme = call_564683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564683.url(scheme.get, call_564683.host, call_564683.base,
                         call_564683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564683, url, valid)

proc call*(call_564684: Call_OfficeConsentsList_564675; subscriptionId: string;
          operationalInsightsResourceProvider: string; resourceGroupName: string;
          workspaceName: string; apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsList
  ## Gets all office365 consents.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564685 = newJObject()
  var query_564686 = newJObject()
  add(query_564686, "api-version", newJString(apiVersion))
  add(path_564685, "subscriptionId", newJString(subscriptionId))
  add(path_564685, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564685, "resourceGroupName", newJString(resourceGroupName))
  add(path_564685, "workspaceName", newJString(workspaceName))
  result = call_564684.call(path_564685, query_564686, nil, nil, nil)

var officeConsentsList* = Call_OfficeConsentsList_564675(
    name: "officeConsentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents",
    validator: validate_OfficeConsentsList_564676, base: "",
    url: url_OfficeConsentsList_564677, schemes: {Scheme.Https})
type
  Call_OfficeConsentsGet_564687 = ref object of OpenApiRestCall_563565
proc url_OfficeConsentsGet_564689(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "consentId" in path, "`consentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/officeConsents/"),
               (kind: VariableSegment, value: "consentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfficeConsentsGet_564688(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets an office365 consent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: JString (required)
  ##            : consent ID
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564690 = path.getOrDefault("subscriptionId")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = nil)
  if valid_564690 != nil:
    section.add "subscriptionId", valid_564690
  var valid_564691 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564691 = validateParameter(valid_564691, JString, required = true,
                                 default = nil)
  if valid_564691 != nil:
    section.add "operationalInsightsResourceProvider", valid_564691
  var valid_564692 = path.getOrDefault("consentId")
  valid_564692 = validateParameter(valid_564692, JString, required = true,
                                 default = nil)
  if valid_564692 != nil:
    section.add "consentId", valid_564692
  var valid_564693 = path.getOrDefault("resourceGroupName")
  valid_564693 = validateParameter(valid_564693, JString, required = true,
                                 default = nil)
  if valid_564693 != nil:
    section.add "resourceGroupName", valid_564693
  var valid_564694 = path.getOrDefault("workspaceName")
  valid_564694 = validateParameter(valid_564694, JString, required = true,
                                 default = nil)
  if valid_564694 != nil:
    section.add "workspaceName", valid_564694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564695 = query.getOrDefault("api-version")
  valid_564695 = validateParameter(valid_564695, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564695 != nil:
    section.add "api-version", valid_564695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564696: Call_OfficeConsentsGet_564687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an office365 consent.
  ## 
  let valid = call_564696.validator(path, query, header, formData, body)
  let scheme = call_564696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564696.url(scheme.get, call_564696.host, call_564696.base,
                         call_564696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564696, url, valid)

proc call*(call_564697: Call_OfficeConsentsGet_564687; subscriptionId: string;
          operationalInsightsResourceProvider: string; consentId: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsGet
  ## Gets an office365 consent.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: string (required)
  ##            : consent ID
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564698 = newJObject()
  var query_564699 = newJObject()
  add(query_564699, "api-version", newJString(apiVersion))
  add(path_564698, "subscriptionId", newJString(subscriptionId))
  add(path_564698, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564698, "consentId", newJString(consentId))
  add(path_564698, "resourceGroupName", newJString(resourceGroupName))
  add(path_564698, "workspaceName", newJString(workspaceName))
  result = call_564697.call(path_564698, query_564699, nil, nil, nil)

var officeConsentsGet* = Call_OfficeConsentsGet_564687(name: "officeConsentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents/{consentId}",
    validator: validate_OfficeConsentsGet_564688, base: "",
    url: url_OfficeConsentsGet_564689, schemes: {Scheme.Https})
type
  Call_OfficeConsentsDelete_564700 = ref object of OpenApiRestCall_563565
proc url_OfficeConsentsDelete_564702(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "consentId" in path, "`consentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/officeConsents/"),
               (kind: VariableSegment, value: "consentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OfficeConsentsDelete_564701(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the office365 consent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: JString (required)
  ##            : consent ID
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564703 = path.getOrDefault("subscriptionId")
  valid_564703 = validateParameter(valid_564703, JString, required = true,
                                 default = nil)
  if valid_564703 != nil:
    section.add "subscriptionId", valid_564703
  var valid_564704 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564704 = validateParameter(valid_564704, JString, required = true,
                                 default = nil)
  if valid_564704 != nil:
    section.add "operationalInsightsResourceProvider", valid_564704
  var valid_564705 = path.getOrDefault("consentId")
  valid_564705 = validateParameter(valid_564705, JString, required = true,
                                 default = nil)
  if valid_564705 != nil:
    section.add "consentId", valid_564705
  var valid_564706 = path.getOrDefault("resourceGroupName")
  valid_564706 = validateParameter(valid_564706, JString, required = true,
                                 default = nil)
  if valid_564706 != nil:
    section.add "resourceGroupName", valid_564706
  var valid_564707 = path.getOrDefault("workspaceName")
  valid_564707 = validateParameter(valid_564707, JString, required = true,
                                 default = nil)
  if valid_564707 != nil:
    section.add "workspaceName", valid_564707
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564708 = query.getOrDefault("api-version")
  valid_564708 = validateParameter(valid_564708, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564708 != nil:
    section.add "api-version", valid_564708
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564709: Call_OfficeConsentsDelete_564700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the office365 consent.
  ## 
  let valid = call_564709.validator(path, query, header, formData, body)
  let scheme = call_564709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564709.url(scheme.get, call_564709.host, call_564709.base,
                         call_564709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564709, url, valid)

proc call*(call_564710: Call_OfficeConsentsDelete_564700; subscriptionId: string;
          operationalInsightsResourceProvider: string; consentId: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsDelete
  ## Delete the office365 consent.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: string (required)
  ##            : consent ID
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564711 = newJObject()
  var query_564712 = newJObject()
  add(query_564712, "api-version", newJString(apiVersion))
  add(path_564711, "subscriptionId", newJString(subscriptionId))
  add(path_564711, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564711, "consentId", newJString(consentId))
  add(path_564711, "resourceGroupName", newJString(resourceGroupName))
  add(path_564711, "workspaceName", newJString(workspaceName))
  result = call_564710.call(path_564711, query_564712, nil, nil, nil)

var officeConsentsDelete* = Call_OfficeConsentsDelete_564700(
    name: "officeConsentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents/{consentId}",
    validator: validate_OfficeConsentsDelete_564701, base: "",
    url: url_OfficeConsentsDelete_564702, schemes: {Scheme.Https})
type
  Call_ProductSettingsUpdate_564726 = ref object of OpenApiRestCall_563565
proc url_ProductSettingsUpdate_564728(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "settingsName" in path, "`settingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/settings/"),
               (kind: VariableSegment, value: "settingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSettingsUpdate_564727(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingsName: JString (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingsName` field"
  var valid_564729 = path.getOrDefault("settingsName")
  valid_564729 = validateParameter(valid_564729, JString, required = true,
                                 default = nil)
  if valid_564729 != nil:
    section.add "settingsName", valid_564729
  var valid_564730 = path.getOrDefault("subscriptionId")
  valid_564730 = validateParameter(valid_564730, JString, required = true,
                                 default = nil)
  if valid_564730 != nil:
    section.add "subscriptionId", valid_564730
  var valid_564731 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = nil)
  if valid_564731 != nil:
    section.add "operationalInsightsResourceProvider", valid_564731
  var valid_564732 = path.getOrDefault("resourceGroupName")
  valid_564732 = validateParameter(valid_564732, JString, required = true,
                                 default = nil)
  if valid_564732 != nil:
    section.add "resourceGroupName", valid_564732
  var valid_564733 = path.getOrDefault("workspaceName")
  valid_564733 = validateParameter(valid_564733, JString, required = true,
                                 default = nil)
  if valid_564733 != nil:
    section.add "workspaceName", valid_564733
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564734 = query.getOrDefault("api-version")
  valid_564734 = validateParameter(valid_564734, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564734 != nil:
    section.add "api-version", valid_564734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   settings: JObject (required)
  ##           : The setting
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564736: Call_ProductSettingsUpdate_564726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the setting.
  ## 
  let valid = call_564736.validator(path, query, header, formData, body)
  let scheme = call_564736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564736.url(scheme.get, call_564736.host, call_564736.base,
                         call_564736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564736, url, valid)

proc call*(call_564737: Call_ProductSettingsUpdate_564726; settingsName: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string; settings: JsonNode;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## productSettingsUpdate
  ## Updates the setting.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingsName: string (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   settings: JObject (required)
  ##           : The setting
  var path_564738 = newJObject()
  var query_564739 = newJObject()
  var body_564740 = newJObject()
  add(query_564739, "api-version", newJString(apiVersion))
  add(path_564738, "settingsName", newJString(settingsName))
  add(path_564738, "subscriptionId", newJString(subscriptionId))
  add(path_564738, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564738, "resourceGroupName", newJString(resourceGroupName))
  add(path_564738, "workspaceName", newJString(workspaceName))
  if settings != nil:
    body_564740 = settings
  result = call_564737.call(path_564738, query_564739, nil, nil, body_564740)

var productSettingsUpdate* = Call_ProductSettingsUpdate_564726(
    name: "productSettingsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/settings/{settingsName}",
    validator: validate_ProductSettingsUpdate_564727, base: "",
    url: url_ProductSettingsUpdate_564728, schemes: {Scheme.Https})
type
  Call_ProductSettingsGet_564713 = ref object of OpenApiRestCall_563565
proc url_ProductSettingsGet_564715(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "operationalInsightsResourceProvider" in path,
        "`operationalInsightsResourceProvider` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "settingsName" in path, "`settingsName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"), (
        kind: VariableSegment, value: "operationalInsightsResourceProvider"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.SecurityInsights/settings/"),
               (kind: VariableSegment, value: "settingsName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProductSettingsGet_564714(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   settingsName: JString (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `settingsName` field"
  var valid_564716 = path.getOrDefault("settingsName")
  valid_564716 = validateParameter(valid_564716, JString, required = true,
                                 default = nil)
  if valid_564716 != nil:
    section.add "settingsName", valid_564716
  var valid_564717 = path.getOrDefault("subscriptionId")
  valid_564717 = validateParameter(valid_564717, JString, required = true,
                                 default = nil)
  if valid_564717 != nil:
    section.add "subscriptionId", valid_564717
  var valid_564718 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_564718 = validateParameter(valid_564718, JString, required = true,
                                 default = nil)
  if valid_564718 != nil:
    section.add "operationalInsightsResourceProvider", valid_564718
  var valid_564719 = path.getOrDefault("resourceGroupName")
  valid_564719 = validateParameter(valid_564719, JString, required = true,
                                 default = nil)
  if valid_564719 != nil:
    section.add "resourceGroupName", valid_564719
  var valid_564720 = path.getOrDefault("workspaceName")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "workspaceName", valid_564720
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564721 = query.getOrDefault("api-version")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_564721 != nil:
    section.add "api-version", valid_564721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564722: Call_ProductSettingsGet_564713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a setting.
  ## 
  let valid = call_564722.validator(path, query, header, formData, body)
  let scheme = call_564722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564722.url(scheme.get, call_564722.host, call_564722.base,
                         call_564722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564722, url, valid)

proc call*(call_564723: Call_ProductSettingsGet_564713; settingsName: string;
          subscriptionId: string; operationalInsightsResourceProvider: string;
          resourceGroupName: string; workspaceName: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## productSettingsGet
  ## Gets a setting.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   settingsName: string (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  var path_564724 = newJObject()
  var query_564725 = newJObject()
  add(query_564725, "api-version", newJString(apiVersion))
  add(path_564724, "settingsName", newJString(settingsName))
  add(path_564724, "subscriptionId", newJString(subscriptionId))
  add(path_564724, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_564724, "resourceGroupName", newJString(resourceGroupName))
  add(path_564724, "workspaceName", newJString(workspaceName))
  result = call_564723.call(path_564724, query_564725, nil, nil, nil)

var productSettingsGet* = Call_ProductSettingsGet_564713(
    name: "productSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/settings/{settingsName}",
    validator: validate_ProductSettingsGet_564714, base: "",
    url: url_ProductSettingsGet_564715, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

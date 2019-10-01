
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567667 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567667](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567667): Option[Scheme] {.used.} =
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
  macServiceName = "securityinsights-SecurityInsights"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567889 = ref object of OpenApiRestCall_567667
proc url_OperationsList_567891(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567890(path: JsonNode; query: JsonNode;
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
  var valid_568063 = query.getOrDefault("api-version")
  valid_568063 = validateParameter(valid_568063, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568063 != nil:
    section.add "api-version", valid_568063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568086: Call_OperationsList_567889; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all operations available Azure Security Insights Resource Provider.
  ## 
  let valid = call_568086.validator(path, query, header, formData, body)
  let scheme = call_568086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568086.url(scheme.get, call_568086.host, call_568086.base,
                         call_568086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568086, url, valid)

proc call*(call_568157: Call_OperationsList_567889;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## operationsList
  ## Lists all operations available Azure Security Insights Resource Provider.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  var query_568158 = newJObject()
  add(query_568158, "api-version", newJString(apiVersion))
  result = call_568157.call(nil, query_568158, nil, nil, nil)

var operationsList* = Call_OperationsList_567889(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.SecurityInsights/operations",
    validator: validate_OperationsList_567890, base: "", url: url_OperationsList_567891,
    schemes: {Scheme.Https})
type
  Call_CasesAggregationsGet_568198 = ref object of OpenApiRestCall_567667
proc url_CasesAggregationsGet_568200(protocol: Scheme; host: string; base: string;
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

proc validate_CasesAggregationsGet_568199(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get aggregative result for the given resources under the defined workspace
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   aggregationsName: JString (required)
  ##                   : The aggregation name. Supports - Cases
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568215 = path.getOrDefault("resourceGroupName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceGroupName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  var valid_568217 = path.getOrDefault("aggregationsName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "aggregationsName", valid_568217
  var valid_568218 = path.getOrDefault("workspaceName")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "workspaceName", valid_568218
  var valid_568219 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568219 = validateParameter(valid_568219, JString, required = true,
                                 default = nil)
  if valid_568219 != nil:
    section.add "operationalInsightsResourceProvider", valid_568219
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568220 = query.getOrDefault("api-version")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568220 != nil:
    section.add "api-version", valid_568220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568221: Call_CasesAggregationsGet_568198; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get aggregative result for the given resources under the defined workspace
  ## 
  let valid = call_568221.validator(path, query, header, formData, body)
  let scheme = call_568221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568221.url(scheme.get, call_568221.host, call_568221.base,
                         call_568221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568221, url, valid)

proc call*(call_568222: Call_CasesAggregationsGet_568198;
          resourceGroupName: string; subscriptionId: string;
          aggregationsName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesAggregationsGet
  ## Get aggregative result for the given resources under the defined workspace
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   aggregationsName: string (required)
  ##                   : The aggregation name. Supports - Cases
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568223 = newJObject()
  var query_568224 = newJObject()
  add(path_568223, "resourceGroupName", newJString(resourceGroupName))
  add(query_568224, "api-version", newJString(apiVersion))
  add(path_568223, "subscriptionId", newJString(subscriptionId))
  add(path_568223, "aggregationsName", newJString(aggregationsName))
  add(path_568223, "workspaceName", newJString(workspaceName))
  add(path_568223, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568222.call(path_568223, query_568224, nil, nil, nil)

var casesAggregationsGet* = Call_CasesAggregationsGet_568198(
    name: "casesAggregationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/aggregations/{aggregationsName}",
    validator: validate_CasesAggregationsGet_568199, base: "",
    url: url_CasesAggregationsGet_568200, schemes: {Scheme.Https})
type
  Call_AlertRuleTemplatesList_568225 = ref object of OpenApiRestCall_567667
proc url_AlertRuleTemplatesList_568227(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRuleTemplatesList_568226(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all alert rule templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("subscriptionId")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "subscriptionId", valid_568229
  var valid_568230 = path.getOrDefault("workspaceName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "workspaceName", valid_568230
  var valid_568231 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "operationalInsightsResourceProvider", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_AlertRuleTemplatesList_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all alert rule templates.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_AlertRuleTemplatesList_568225;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRuleTemplatesList
  ## Gets all alert rule templates.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(path_568235, "resourceGroupName", newJString(resourceGroupName))
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  add(path_568235, "workspaceName", newJString(workspaceName))
  add(path_568235, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var alertRuleTemplatesList* = Call_AlertRuleTemplatesList_568225(
    name: "alertRuleTemplatesList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRuleTemplates",
    validator: validate_AlertRuleTemplatesList_568226, base: "",
    url: url_AlertRuleTemplatesList_568227, schemes: {Scheme.Https})
type
  Call_AlertRuleTemplatesGet_568237 = ref object of OpenApiRestCall_567667
proc url_AlertRuleTemplatesGet_568239(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRuleTemplatesGet_568238(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert rule template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   alertRuleTemplateId: JString (required)
  ##                      : Alert rule template ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("alertRuleTemplateId")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "alertRuleTemplateId", valid_568242
  var valid_568243 = path.getOrDefault("workspaceName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "workspaceName", valid_568243
  var valid_568244 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "operationalInsightsResourceProvider", valid_568244
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568245 = query.getOrDefault("api-version")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568245 != nil:
    section.add "api-version", valid_568245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568246: Call_AlertRuleTemplatesGet_568237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert rule template.
  ## 
  let valid = call_568246.validator(path, query, header, formData, body)
  let scheme = call_568246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568246.url(scheme.get, call_568246.host, call_568246.base,
                         call_568246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568246, url, valid)

proc call*(call_568247: Call_AlertRuleTemplatesGet_568237;
          resourceGroupName: string; subscriptionId: string;
          alertRuleTemplateId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRuleTemplatesGet
  ## Gets the alert rule template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   alertRuleTemplateId: string (required)
  ##                      : Alert rule template ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568248 = newJObject()
  var query_568249 = newJObject()
  add(path_568248, "resourceGroupName", newJString(resourceGroupName))
  add(query_568249, "api-version", newJString(apiVersion))
  add(path_568248, "subscriptionId", newJString(subscriptionId))
  add(path_568248, "alertRuleTemplateId", newJString(alertRuleTemplateId))
  add(path_568248, "workspaceName", newJString(workspaceName))
  add(path_568248, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568247.call(path_568248, query_568249, nil, nil, nil)

var alertRuleTemplatesGet* = Call_AlertRuleTemplatesGet_568237(
    name: "alertRuleTemplatesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRuleTemplates/{alertRuleTemplateId}",
    validator: validate_AlertRuleTemplatesGet_568238, base: "",
    url: url_AlertRuleTemplatesGet_568239, schemes: {Scheme.Https})
type
  Call_AlertRulesList_568250 = ref object of OpenApiRestCall_567667
proc url_AlertRulesList_568252(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRulesList_568251(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets all alert rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568253 = path.getOrDefault("resourceGroupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "resourceGroupName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568255 = path.getOrDefault("workspaceName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "workspaceName", valid_568255
  var valid_568256 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "operationalInsightsResourceProvider", valid_568256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568257 = query.getOrDefault("api-version")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568257 != nil:
    section.add "api-version", valid_568257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568258: Call_AlertRulesList_568250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all alert rules.
  ## 
  let valid = call_568258.validator(path, query, header, formData, body)
  let scheme = call_568258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568258.url(scheme.get, call_568258.host, call_568258.base,
                         call_568258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568258, url, valid)

proc call*(call_568259: Call_AlertRulesList_568250; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesList
  ## Gets all alert rules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568260 = newJObject()
  var query_568261 = newJObject()
  add(path_568260, "resourceGroupName", newJString(resourceGroupName))
  add(query_568261, "api-version", newJString(apiVersion))
  add(path_568260, "subscriptionId", newJString(subscriptionId))
  add(path_568260, "workspaceName", newJString(workspaceName))
  add(path_568260, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568259.call(path_568260, query_568261, nil, nil, nil)

var alertRulesList* = Call_AlertRulesList_568250(name: "alertRulesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules",
    validator: validate_AlertRulesList_568251, base: "", url: url_AlertRulesList_568252,
    schemes: {Scheme.Https})
type
  Call_AlertRulesCreateOrUpdate_568275 = ref object of OpenApiRestCall_567667
proc url_AlertRulesCreateOrUpdate_568277(protocol: Scheme; host: string;
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

proc validate_AlertRulesCreateOrUpdate_568276(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568278 = path.getOrDefault("resourceGroupName")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "resourceGroupName", valid_568278
  var valid_568279 = path.getOrDefault("subscriptionId")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "subscriptionId", valid_568279
  var valid_568280 = path.getOrDefault("ruleId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "ruleId", valid_568280
  var valid_568281 = path.getOrDefault("workspaceName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "workspaceName", valid_568281
  var valid_568282 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "operationalInsightsResourceProvider", valid_568282
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568283 = query.getOrDefault("api-version")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568283 != nil:
    section.add "api-version", valid_568283
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

proc call*(call_568285: Call_AlertRulesCreateOrUpdate_568275; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the alert rule.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_AlertRulesCreateOrUpdate_568275;
          resourceGroupName: string; alertRule: JsonNode; subscriptionId: string;
          ruleId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesCreateOrUpdate
  ## Creates or updates the alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   alertRule: JObject (required)
  ##            : The alert rule
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  var body_568289 = newJObject()
  add(path_568287, "resourceGroupName", newJString(resourceGroupName))
  add(query_568288, "api-version", newJString(apiVersion))
  if alertRule != nil:
    body_568289 = alertRule
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  add(path_568287, "ruleId", newJString(ruleId))
  add(path_568287, "workspaceName", newJString(workspaceName))
  add(path_568287, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568286.call(path_568287, query_568288, nil, nil, body_568289)

var alertRulesCreateOrUpdate* = Call_AlertRulesCreateOrUpdate_568275(
    name: "alertRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesCreateOrUpdate_568276, base: "",
    url: url_AlertRulesCreateOrUpdate_568277, schemes: {Scheme.Https})
type
  Call_AlertRulesGet_568262 = ref object of OpenApiRestCall_567667
proc url_AlertRulesGet_568264(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRulesGet_568263(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568265 = path.getOrDefault("resourceGroupName")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "resourceGroupName", valid_568265
  var valid_568266 = path.getOrDefault("subscriptionId")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "subscriptionId", valid_568266
  var valid_568267 = path.getOrDefault("ruleId")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "ruleId", valid_568267
  var valid_568268 = path.getOrDefault("workspaceName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "workspaceName", valid_568268
  var valid_568269 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "operationalInsightsResourceProvider", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568270 = query.getOrDefault("api-version")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568270 != nil:
    section.add "api-version", valid_568270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568271: Call_AlertRulesGet_568262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the alert rule.
  ## 
  let valid = call_568271.validator(path, query, header, formData, body)
  let scheme = call_568271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568271.url(scheme.get, call_568271.host, call_568271.base,
                         call_568271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568271, url, valid)

proc call*(call_568272: Call_AlertRulesGet_568262; resourceGroupName: string;
          subscriptionId: string; ruleId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesGet
  ## Gets the alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568273 = newJObject()
  var query_568274 = newJObject()
  add(path_568273, "resourceGroupName", newJString(resourceGroupName))
  add(query_568274, "api-version", newJString(apiVersion))
  add(path_568273, "subscriptionId", newJString(subscriptionId))
  add(path_568273, "ruleId", newJString(ruleId))
  add(path_568273, "workspaceName", newJString(workspaceName))
  add(path_568273, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568272.call(path_568273, query_568274, nil, nil, nil)

var alertRulesGet* = Call_AlertRulesGet_568262(name: "alertRulesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesGet_568263, base: "", url: url_AlertRulesGet_568264,
    schemes: {Scheme.Https})
type
  Call_AlertRulesDelete_568290 = ref object of OpenApiRestCall_567667
proc url_AlertRulesDelete_568292(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRulesDelete_568291(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Delete the alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568293 = path.getOrDefault("resourceGroupName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceGroupName", valid_568293
  var valid_568294 = path.getOrDefault("subscriptionId")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "subscriptionId", valid_568294
  var valid_568295 = path.getOrDefault("ruleId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "ruleId", valid_568295
  var valid_568296 = path.getOrDefault("workspaceName")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "workspaceName", valid_568296
  var valid_568297 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "operationalInsightsResourceProvider", valid_568297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_AlertRulesDelete_568290; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the alert rule.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_AlertRulesDelete_568290; resourceGroupName: string;
          subscriptionId: string; ruleId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesDelete
  ## Delete the alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  add(path_568301, "ruleId", newJString(ruleId))
  add(path_568301, "workspaceName", newJString(workspaceName))
  add(path_568301, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var alertRulesDelete* = Call_AlertRulesDelete_568290(name: "alertRulesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}",
    validator: validate_AlertRulesDelete_568291, base: "",
    url: url_AlertRulesDelete_568292, schemes: {Scheme.Https})
type
  Call_ActionsListByAlertRule_568303 = ref object of OpenApiRestCall_567667
proc url_ActionsListByAlertRule_568305(protocol: Scheme; host: string; base: string;
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

proc validate_ActionsListByAlertRule_568304(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all actions of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568306 = path.getOrDefault("resourceGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceGroupName", valid_568306
  var valid_568307 = path.getOrDefault("subscriptionId")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "subscriptionId", valid_568307
  var valid_568308 = path.getOrDefault("ruleId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "ruleId", valid_568308
  var valid_568309 = path.getOrDefault("workspaceName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "workspaceName", valid_568309
  var valid_568310 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "operationalInsightsResourceProvider", valid_568310
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568311 = query.getOrDefault("api-version")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568311 != nil:
    section.add "api-version", valid_568311
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568312: Call_ActionsListByAlertRule_568303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all actions of alert rule.
  ## 
  let valid = call_568312.validator(path, query, header, formData, body)
  let scheme = call_568312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568312.url(scheme.get, call_568312.host, call_568312.base,
                         call_568312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568312, url, valid)

proc call*(call_568313: Call_ActionsListByAlertRule_568303;
          resourceGroupName: string; subscriptionId: string; ruleId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## actionsListByAlertRule
  ## Gets all actions of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568314 = newJObject()
  var query_568315 = newJObject()
  add(path_568314, "resourceGroupName", newJString(resourceGroupName))
  add(query_568315, "api-version", newJString(apiVersion))
  add(path_568314, "subscriptionId", newJString(subscriptionId))
  add(path_568314, "ruleId", newJString(ruleId))
  add(path_568314, "workspaceName", newJString(workspaceName))
  add(path_568314, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568313.call(path_568314, query_568315, nil, nil, nil)

var actionsListByAlertRule* = Call_ActionsListByAlertRule_568303(
    name: "actionsListByAlertRule", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions",
    validator: validate_ActionsListByAlertRule_568304, base: "",
    url: url_ActionsListByAlertRule_568305, schemes: {Scheme.Https})
type
  Call_AlertRulesCreateOrUpdateAction_568330 = ref object of OpenApiRestCall_567667
proc url_AlertRulesCreateOrUpdateAction_568332(protocol: Scheme; host: string;
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

proc validate_AlertRulesCreateOrUpdateAction_568331(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568333 = path.getOrDefault("resourceGroupName")
  valid_568333 = validateParameter(valid_568333, JString, required = true,
                                 default = nil)
  if valid_568333 != nil:
    section.add "resourceGroupName", valid_568333
  var valid_568334 = path.getOrDefault("subscriptionId")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "subscriptionId", valid_568334
  var valid_568335 = path.getOrDefault("ruleId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "ruleId", valid_568335
  var valid_568336 = path.getOrDefault("actionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "actionId", valid_568336
  var valid_568337 = path.getOrDefault("workspaceName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "workspaceName", valid_568337
  var valid_568338 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "operationalInsightsResourceProvider", valid_568338
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568339 = query.getOrDefault("api-version")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568339 != nil:
    section.add "api-version", valid_568339
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

proc call*(call_568341: Call_AlertRulesCreateOrUpdateAction_568330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the action of alert rule.
  ## 
  let valid = call_568341.validator(path, query, header, formData, body)
  let scheme = call_568341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568341.url(scheme.get, call_568341.host, call_568341.base,
                         call_568341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568341, url, valid)

proc call*(call_568342: Call_AlertRulesCreateOrUpdateAction_568330;
          resourceGroupName: string; action: JsonNode; subscriptionId: string;
          ruleId: string; actionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesCreateOrUpdateAction
  ## Creates or updates the action of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   action: JObject (required)
  ##         : The action
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   actionId: string (required)
  ##           : Action ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568343 = newJObject()
  var query_568344 = newJObject()
  var body_568345 = newJObject()
  add(path_568343, "resourceGroupName", newJString(resourceGroupName))
  if action != nil:
    body_568345 = action
  add(query_568344, "api-version", newJString(apiVersion))
  add(path_568343, "subscriptionId", newJString(subscriptionId))
  add(path_568343, "ruleId", newJString(ruleId))
  add(path_568343, "actionId", newJString(actionId))
  add(path_568343, "workspaceName", newJString(workspaceName))
  add(path_568343, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568342.call(path_568343, query_568344, nil, nil, body_568345)

var alertRulesCreateOrUpdateAction* = Call_AlertRulesCreateOrUpdateAction_568330(
    name: "alertRulesCreateOrUpdateAction", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesCreateOrUpdateAction_568331, base: "",
    url: url_AlertRulesCreateOrUpdateAction_568332, schemes: {Scheme.Https})
type
  Call_AlertRulesGetAction_568316 = ref object of OpenApiRestCall_567667
proc url_AlertRulesGetAction_568318(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRulesGetAction_568317(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568319 = path.getOrDefault("resourceGroupName")
  valid_568319 = validateParameter(valid_568319, JString, required = true,
                                 default = nil)
  if valid_568319 != nil:
    section.add "resourceGroupName", valid_568319
  var valid_568320 = path.getOrDefault("subscriptionId")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "subscriptionId", valid_568320
  var valid_568321 = path.getOrDefault("ruleId")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "ruleId", valid_568321
  var valid_568322 = path.getOrDefault("actionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "actionId", valid_568322
  var valid_568323 = path.getOrDefault("workspaceName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "workspaceName", valid_568323
  var valid_568324 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "operationalInsightsResourceProvider", valid_568324
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568325 = query.getOrDefault("api-version")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568325 != nil:
    section.add "api-version", valid_568325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568326: Call_AlertRulesGetAction_568316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the action of alert rule.
  ## 
  let valid = call_568326.validator(path, query, header, formData, body)
  let scheme = call_568326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568326.url(scheme.get, call_568326.host, call_568326.base,
                         call_568326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568326, url, valid)

proc call*(call_568327: Call_AlertRulesGetAction_568316; resourceGroupName: string;
          subscriptionId: string; ruleId: string; actionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesGetAction
  ## Gets the action of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   actionId: string (required)
  ##           : Action ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568328 = newJObject()
  var query_568329 = newJObject()
  add(path_568328, "resourceGroupName", newJString(resourceGroupName))
  add(query_568329, "api-version", newJString(apiVersion))
  add(path_568328, "subscriptionId", newJString(subscriptionId))
  add(path_568328, "ruleId", newJString(ruleId))
  add(path_568328, "actionId", newJString(actionId))
  add(path_568328, "workspaceName", newJString(workspaceName))
  add(path_568328, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568327.call(path_568328, query_568329, nil, nil, nil)

var alertRulesGetAction* = Call_AlertRulesGetAction_568316(
    name: "alertRulesGetAction", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesGetAction_568317, base: "",
    url: url_AlertRulesGetAction_568318, schemes: {Scheme.Https})
type
  Call_AlertRulesDeleteAction_568346 = ref object of OpenApiRestCall_567667
proc url_AlertRulesDeleteAction_568348(protocol: Scheme; host: string; base: string;
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

proc validate_AlertRulesDeleteAction_568347(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the action of alert rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   ruleId: JString (required)
  ##         : Alert rule ID
  ##   actionId: JString (required)
  ##           : Action ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568349 = path.getOrDefault("resourceGroupName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "resourceGroupName", valid_568349
  var valid_568350 = path.getOrDefault("subscriptionId")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = nil)
  if valid_568350 != nil:
    section.add "subscriptionId", valid_568350
  var valid_568351 = path.getOrDefault("ruleId")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "ruleId", valid_568351
  var valid_568352 = path.getOrDefault("actionId")
  valid_568352 = validateParameter(valid_568352, JString, required = true,
                                 default = nil)
  if valid_568352 != nil:
    section.add "actionId", valid_568352
  var valid_568353 = path.getOrDefault("workspaceName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "workspaceName", valid_568353
  var valid_568354 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "operationalInsightsResourceProvider", valid_568354
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568355 = query.getOrDefault("api-version")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568355 != nil:
    section.add "api-version", valid_568355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568356: Call_AlertRulesDeleteAction_568346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the action of alert rule.
  ## 
  let valid = call_568356.validator(path, query, header, formData, body)
  let scheme = call_568356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568356.url(scheme.get, call_568356.host, call_568356.base,
                         call_568356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568356, url, valid)

proc call*(call_568357: Call_AlertRulesDeleteAction_568346;
          resourceGroupName: string; subscriptionId: string; ruleId: string;
          actionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## alertRulesDeleteAction
  ## Delete the action of alert rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   ruleId: string (required)
  ##         : Alert rule ID
  ##   actionId: string (required)
  ##           : Action ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568358 = newJObject()
  var query_568359 = newJObject()
  add(path_568358, "resourceGroupName", newJString(resourceGroupName))
  add(query_568359, "api-version", newJString(apiVersion))
  add(path_568358, "subscriptionId", newJString(subscriptionId))
  add(path_568358, "ruleId", newJString(ruleId))
  add(path_568358, "actionId", newJString(actionId))
  add(path_568358, "workspaceName", newJString(workspaceName))
  add(path_568358, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568357.call(path_568358, query_568359, nil, nil, nil)

var alertRulesDeleteAction* = Call_AlertRulesDeleteAction_568346(
    name: "alertRulesDeleteAction", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/alertRules/{ruleId}/actions/{actionId}",
    validator: validate_AlertRulesDeleteAction_568347, base: "",
    url: url_AlertRulesDeleteAction_568348, schemes: {Scheme.Https})
type
  Call_BookmarksList_568360 = ref object of OpenApiRestCall_567667
proc url_BookmarksList_568362(protocol: Scheme; host: string; base: string;
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

proc validate_BookmarksList_568361(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all bookmarks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568363 = path.getOrDefault("resourceGroupName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = nil)
  if valid_568363 != nil:
    section.add "resourceGroupName", valid_568363
  var valid_568364 = path.getOrDefault("subscriptionId")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "subscriptionId", valid_568364
  var valid_568365 = path.getOrDefault("workspaceName")
  valid_568365 = validateParameter(valid_568365, JString, required = true,
                                 default = nil)
  if valid_568365 != nil:
    section.add "workspaceName", valid_568365
  var valid_568366 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568366 = validateParameter(valid_568366, JString, required = true,
                                 default = nil)
  if valid_568366 != nil:
    section.add "operationalInsightsResourceProvider", valid_568366
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568367 = query.getOrDefault("api-version")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568367 != nil:
    section.add "api-version", valid_568367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568368: Call_BookmarksList_568360; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all bookmarks.
  ## 
  let valid = call_568368.validator(path, query, header, formData, body)
  let scheme = call_568368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568368.url(scheme.get, call_568368.host, call_568368.base,
                         call_568368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568368, url, valid)

proc call*(call_568369: Call_BookmarksList_568360; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksList
  ## Gets all bookmarks.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568370 = newJObject()
  var query_568371 = newJObject()
  add(path_568370, "resourceGroupName", newJString(resourceGroupName))
  add(query_568371, "api-version", newJString(apiVersion))
  add(path_568370, "subscriptionId", newJString(subscriptionId))
  add(path_568370, "workspaceName", newJString(workspaceName))
  add(path_568370, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568369.call(path_568370, query_568371, nil, nil, nil)

var bookmarksList* = Call_BookmarksList_568360(name: "bookmarksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks",
    validator: validate_BookmarksList_568361, base: "", url: url_BookmarksList_568362,
    schemes: {Scheme.Https})
type
  Call_BookmarksCreateOrUpdate_568385 = ref object of OpenApiRestCall_567667
proc url_BookmarksCreateOrUpdate_568387(protocol: Scheme; host: string; base: string;
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

proc validate_BookmarksCreateOrUpdate_568386(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568388 = path.getOrDefault("resourceGroupName")
  valid_568388 = validateParameter(valid_568388, JString, required = true,
                                 default = nil)
  if valid_568388 != nil:
    section.add "resourceGroupName", valid_568388
  var valid_568389 = path.getOrDefault("bookmarkId")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "bookmarkId", valid_568389
  var valid_568390 = path.getOrDefault("subscriptionId")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "subscriptionId", valid_568390
  var valid_568391 = path.getOrDefault("workspaceName")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "workspaceName", valid_568391
  var valid_568392 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "operationalInsightsResourceProvider", valid_568392
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568393 = query.getOrDefault("api-version")
  valid_568393 = validateParameter(valid_568393, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568393 != nil:
    section.add "api-version", valid_568393
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

proc call*(call_568395: Call_BookmarksCreateOrUpdate_568385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the bookmark.
  ## 
  let valid = call_568395.validator(path, query, header, formData, body)
  let scheme = call_568395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568395.url(scheme.get, call_568395.host, call_568395.base,
                         call_568395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568395, url, valid)

proc call*(call_568396: Call_BookmarksCreateOrUpdate_568385;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          bookmark: JsonNode; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksCreateOrUpdate
  ## Creates or updates the bookmark.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   bookmark: JObject (required)
  ##           : The bookmark
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568397 = newJObject()
  var query_568398 = newJObject()
  var body_568399 = newJObject()
  add(path_568397, "resourceGroupName", newJString(resourceGroupName))
  add(query_568398, "api-version", newJString(apiVersion))
  add(path_568397, "bookmarkId", newJString(bookmarkId))
  add(path_568397, "subscriptionId", newJString(subscriptionId))
  if bookmark != nil:
    body_568399 = bookmark
  add(path_568397, "workspaceName", newJString(workspaceName))
  add(path_568397, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568396.call(path_568397, query_568398, nil, nil, body_568399)

var bookmarksCreateOrUpdate* = Call_BookmarksCreateOrUpdate_568385(
    name: "bookmarksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksCreateOrUpdate_568386, base: "",
    url: url_BookmarksCreateOrUpdate_568387, schemes: {Scheme.Https})
type
  Call_BookmarksGet_568372 = ref object of OpenApiRestCall_567667
proc url_BookmarksGet_568374(protocol: Scheme; host: string; base: string;
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

proc validate_BookmarksGet_568373(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568375 = path.getOrDefault("resourceGroupName")
  valid_568375 = validateParameter(valid_568375, JString, required = true,
                                 default = nil)
  if valid_568375 != nil:
    section.add "resourceGroupName", valid_568375
  var valid_568376 = path.getOrDefault("bookmarkId")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "bookmarkId", valid_568376
  var valid_568377 = path.getOrDefault("subscriptionId")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "subscriptionId", valid_568377
  var valid_568378 = path.getOrDefault("workspaceName")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "workspaceName", valid_568378
  var valid_568379 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568379 = validateParameter(valid_568379, JString, required = true,
                                 default = nil)
  if valid_568379 != nil:
    section.add "operationalInsightsResourceProvider", valid_568379
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568381: Call_BookmarksGet_568372; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a bookmark.
  ## 
  let valid = call_568381.validator(path, query, header, formData, body)
  let scheme = call_568381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568381.url(scheme.get, call_568381.host, call_568381.base,
                         call_568381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568381, url, valid)

proc call*(call_568382: Call_BookmarksGet_568372; resourceGroupName: string;
          bookmarkId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksGet
  ## Gets a bookmark.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568383 = newJObject()
  var query_568384 = newJObject()
  add(path_568383, "resourceGroupName", newJString(resourceGroupName))
  add(query_568384, "api-version", newJString(apiVersion))
  add(path_568383, "bookmarkId", newJString(bookmarkId))
  add(path_568383, "subscriptionId", newJString(subscriptionId))
  add(path_568383, "workspaceName", newJString(workspaceName))
  add(path_568383, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568382.call(path_568383, query_568384, nil, nil, nil)

var bookmarksGet* = Call_BookmarksGet_568372(name: "bookmarksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksGet_568373, base: "", url: url_BookmarksGet_568374,
    schemes: {Scheme.Https})
type
  Call_BookmarksDelete_568400 = ref object of OpenApiRestCall_567667
proc url_BookmarksDelete_568402(protocol: Scheme; host: string; base: string;
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

proc validate_BookmarksDelete_568401(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete the bookmark.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568403 = path.getOrDefault("resourceGroupName")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "resourceGroupName", valid_568403
  var valid_568404 = path.getOrDefault("bookmarkId")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "bookmarkId", valid_568404
  var valid_568405 = path.getOrDefault("subscriptionId")
  valid_568405 = validateParameter(valid_568405, JString, required = true,
                                 default = nil)
  if valid_568405 != nil:
    section.add "subscriptionId", valid_568405
  var valid_568406 = path.getOrDefault("workspaceName")
  valid_568406 = validateParameter(valid_568406, JString, required = true,
                                 default = nil)
  if valid_568406 != nil:
    section.add "workspaceName", valid_568406
  var valid_568407 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568407 = validateParameter(valid_568407, JString, required = true,
                                 default = nil)
  if valid_568407 != nil:
    section.add "operationalInsightsResourceProvider", valid_568407
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568408 = query.getOrDefault("api-version")
  valid_568408 = validateParameter(valid_568408, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568408 != nil:
    section.add "api-version", valid_568408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568409: Call_BookmarksDelete_568400; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the bookmark.
  ## 
  let valid = call_568409.validator(path, query, header, formData, body)
  let scheme = call_568409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568409.url(scheme.get, call_568409.host, call_568409.base,
                         call_568409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568409, url, valid)

proc call*(call_568410: Call_BookmarksDelete_568400; resourceGroupName: string;
          bookmarkId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarksDelete
  ## Delete the bookmark.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568411 = newJObject()
  var query_568412 = newJObject()
  add(path_568411, "resourceGroupName", newJString(resourceGroupName))
  add(query_568412, "api-version", newJString(apiVersion))
  add(path_568411, "bookmarkId", newJString(bookmarkId))
  add(path_568411, "subscriptionId", newJString(subscriptionId))
  add(path_568411, "workspaceName", newJString(workspaceName))
  add(path_568411, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568410.call(path_568411, query_568412, nil, nil, nil)

var bookmarksDelete* = Call_BookmarksDelete_568400(name: "bookmarksDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}",
    validator: validate_BookmarksDelete_568401, base: "", url: url_BookmarksDelete_568402,
    schemes: {Scheme.Https})
type
  Call_BookmarkRelationsList_568413 = ref object of OpenApiRestCall_567667
proc url_BookmarkRelationsList_568415(protocol: Scheme; host: string; base: string;
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

proc validate_BookmarkRelationsList_568414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all bookmark relations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568417 = path.getOrDefault("resourceGroupName")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "resourceGroupName", valid_568417
  var valid_568418 = path.getOrDefault("bookmarkId")
  valid_568418 = validateParameter(valid_568418, JString, required = true,
                                 default = nil)
  if valid_568418 != nil:
    section.add "bookmarkId", valid_568418
  var valid_568419 = path.getOrDefault("subscriptionId")
  valid_568419 = validateParameter(valid_568419, JString, required = true,
                                 default = nil)
  if valid_568419 != nil:
    section.add "subscriptionId", valid_568419
  var valid_568420 = path.getOrDefault("workspaceName")
  valid_568420 = validateParameter(valid_568420, JString, required = true,
                                 default = nil)
  if valid_568420 != nil:
    section.add "workspaceName", valid_568420
  var valid_568421 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568421 = validateParameter(valid_568421, JString, required = true,
                                 default = nil)
  if valid_568421 != nil:
    section.add "operationalInsightsResourceProvider", valid_568421
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_568422 = query.getOrDefault("$orderby")
  valid_568422 = validateParameter(valid_568422, JString, required = false,
                                 default = nil)
  if valid_568422 != nil:
    section.add "$orderby", valid_568422
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568423 = query.getOrDefault("api-version")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568423 != nil:
    section.add "api-version", valid_568423
  var valid_568424 = query.getOrDefault("$top")
  valid_568424 = validateParameter(valid_568424, JInt, required = false, default = nil)
  if valid_568424 != nil:
    section.add "$top", valid_568424
  var valid_568425 = query.getOrDefault("$skipToken")
  valid_568425 = validateParameter(valid_568425, JString, required = false,
                                 default = nil)
  if valid_568425 != nil:
    section.add "$skipToken", valid_568425
  var valid_568426 = query.getOrDefault("$filter")
  valid_568426 = validateParameter(valid_568426, JString, required = false,
                                 default = nil)
  if valid_568426 != nil:
    section.add "$filter", valid_568426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568427: Call_BookmarkRelationsList_568413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all bookmark relations.
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_BookmarkRelationsList_568413;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          Orderby: string = ""; apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## bookmarkRelationsList
  ## Gets all bookmark relations.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  add(query_568430, "$orderby", newJString(Orderby))
  add(path_568429, "resourceGroupName", newJString(resourceGroupName))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "bookmarkId", newJString(bookmarkId))
  add(path_568429, "subscriptionId", newJString(subscriptionId))
  add(query_568430, "$top", newJInt(Top))
  add(query_568430, "$skipToken", newJString(SkipToken))
  add(path_568429, "workspaceName", newJString(workspaceName))
  add(query_568430, "$filter", newJString(Filter))
  add(path_568429, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568428.call(path_568429, query_568430, nil, nil, nil)

var bookmarkRelationsList* = Call_BookmarkRelationsList_568413(
    name: "bookmarkRelationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations",
    validator: validate_BookmarkRelationsList_568414, base: "",
    url: url_BookmarkRelationsList_568415, schemes: {Scheme.Https})
type
  Call_BookmarkRelationsCreateOrUpdateRelation_568445 = ref object of OpenApiRestCall_567667
proc url_BookmarkRelationsCreateOrUpdateRelation_568447(protocol: Scheme;
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

proc validate_BookmarkRelationsCreateOrUpdateRelation_568446(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568448 = path.getOrDefault("resourceGroupName")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "resourceGroupName", valid_568448
  var valid_568449 = path.getOrDefault("bookmarkId")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "bookmarkId", valid_568449
  var valid_568450 = path.getOrDefault("subscriptionId")
  valid_568450 = validateParameter(valid_568450, JString, required = true,
                                 default = nil)
  if valid_568450 != nil:
    section.add "subscriptionId", valid_568450
  var valid_568451 = path.getOrDefault("relationName")
  valid_568451 = validateParameter(valid_568451, JString, required = true,
                                 default = nil)
  if valid_568451 != nil:
    section.add "relationName", valid_568451
  var valid_568452 = path.getOrDefault("workspaceName")
  valid_568452 = validateParameter(valid_568452, JString, required = true,
                                 default = nil)
  if valid_568452 != nil:
    section.add "workspaceName", valid_568452
  var valid_568453 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568453 = validateParameter(valid_568453, JString, required = true,
                                 default = nil)
  if valid_568453 != nil:
    section.add "operationalInsightsResourceProvider", valid_568453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568454 = query.getOrDefault("api-version")
  valid_568454 = validateParameter(valid_568454, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568454 != nil:
    section.add "api-version", valid_568454
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

proc call*(call_568456: Call_BookmarkRelationsCreateOrUpdateRelation_568445;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates the bookmark relation.
  ## 
  let valid = call_568456.validator(path, query, header, formData, body)
  let scheme = call_568456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568456.url(scheme.get, call_568456.host, call_568456.base,
                         call_568456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568456, url, valid)

proc call*(call_568457: Call_BookmarkRelationsCreateOrUpdateRelation_568445;
          resourceGroupName: string; bookmarkId: string;
          relationInputModel: JsonNode; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsCreateOrUpdateRelation
  ## Creates the bookmark relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568458 = newJObject()
  var query_568459 = newJObject()
  var body_568460 = newJObject()
  add(path_568458, "resourceGroupName", newJString(resourceGroupName))
  add(query_568459, "api-version", newJString(apiVersion))
  add(path_568458, "bookmarkId", newJString(bookmarkId))
  if relationInputModel != nil:
    body_568460 = relationInputModel
  add(path_568458, "subscriptionId", newJString(subscriptionId))
  add(path_568458, "relationName", newJString(relationName))
  add(path_568458, "workspaceName", newJString(workspaceName))
  add(path_568458, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568457.call(path_568458, query_568459, nil, nil, body_568460)

var bookmarkRelationsCreateOrUpdateRelation* = Call_BookmarkRelationsCreateOrUpdateRelation_568445(
    name: "bookmarkRelationsCreateOrUpdateRelation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsCreateOrUpdateRelation_568446, base: "",
    url: url_BookmarkRelationsCreateOrUpdateRelation_568447,
    schemes: {Scheme.Https})
type
  Call_BookmarkRelationsGetRelation_568431 = ref object of OpenApiRestCall_567667
proc url_BookmarkRelationsGetRelation_568433(protocol: Scheme; host: string;
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

proc validate_BookmarkRelationsGetRelation_568432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568434 = path.getOrDefault("resourceGroupName")
  valid_568434 = validateParameter(valid_568434, JString, required = true,
                                 default = nil)
  if valid_568434 != nil:
    section.add "resourceGroupName", valid_568434
  var valid_568435 = path.getOrDefault("bookmarkId")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "bookmarkId", valid_568435
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  var valid_568437 = path.getOrDefault("relationName")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "relationName", valid_568437
  var valid_568438 = path.getOrDefault("workspaceName")
  valid_568438 = validateParameter(valid_568438, JString, required = true,
                                 default = nil)
  if valid_568438 != nil:
    section.add "workspaceName", valid_568438
  var valid_568439 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "operationalInsightsResourceProvider", valid_568439
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568440 = query.getOrDefault("api-version")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568440 != nil:
    section.add "api-version", valid_568440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568441: Call_BookmarkRelationsGetRelation_568431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a bookmark relation.
  ## 
  let valid = call_568441.validator(path, query, header, formData, body)
  let scheme = call_568441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568441.url(scheme.get, call_568441.host, call_568441.base,
                         call_568441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568441, url, valid)

proc call*(call_568442: Call_BookmarkRelationsGetRelation_568431;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsGetRelation
  ## Gets a bookmark relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568443 = newJObject()
  var query_568444 = newJObject()
  add(path_568443, "resourceGroupName", newJString(resourceGroupName))
  add(query_568444, "api-version", newJString(apiVersion))
  add(path_568443, "bookmarkId", newJString(bookmarkId))
  add(path_568443, "subscriptionId", newJString(subscriptionId))
  add(path_568443, "relationName", newJString(relationName))
  add(path_568443, "workspaceName", newJString(workspaceName))
  add(path_568443, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568442.call(path_568443, query_568444, nil, nil, nil)

var bookmarkRelationsGetRelation* = Call_BookmarkRelationsGetRelation_568431(
    name: "bookmarkRelationsGetRelation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsGetRelation_568432, base: "",
    url: url_BookmarkRelationsGetRelation_568433, schemes: {Scheme.Https})
type
  Call_BookmarkRelationsDeleteRelation_568461 = ref object of OpenApiRestCall_567667
proc url_BookmarkRelationsDeleteRelation_568463(protocol: Scheme; host: string;
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

proc validate_BookmarkRelationsDeleteRelation_568462(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the bookmark relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   bookmarkId: JString (required)
  ##             : Bookmark ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568464 = path.getOrDefault("resourceGroupName")
  valid_568464 = validateParameter(valid_568464, JString, required = true,
                                 default = nil)
  if valid_568464 != nil:
    section.add "resourceGroupName", valid_568464
  var valid_568465 = path.getOrDefault("bookmarkId")
  valid_568465 = validateParameter(valid_568465, JString, required = true,
                                 default = nil)
  if valid_568465 != nil:
    section.add "bookmarkId", valid_568465
  var valid_568466 = path.getOrDefault("subscriptionId")
  valid_568466 = validateParameter(valid_568466, JString, required = true,
                                 default = nil)
  if valid_568466 != nil:
    section.add "subscriptionId", valid_568466
  var valid_568467 = path.getOrDefault("relationName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "relationName", valid_568467
  var valid_568468 = path.getOrDefault("workspaceName")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "workspaceName", valid_568468
  var valid_568469 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "operationalInsightsResourceProvider", valid_568469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568470 = query.getOrDefault("api-version")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568470 != nil:
    section.add "api-version", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_BookmarkRelationsDeleteRelation_568461;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete the bookmark relation.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_BookmarkRelationsDeleteRelation_568461;
          resourceGroupName: string; bookmarkId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## bookmarkRelationsDeleteRelation
  ## Delete the bookmark relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   bookmarkId: string (required)
  ##             : Bookmark ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(path_568473, "resourceGroupName", newJString(resourceGroupName))
  add(query_568474, "api-version", newJString(apiVersion))
  add(path_568473, "bookmarkId", newJString(bookmarkId))
  add(path_568473, "subscriptionId", newJString(subscriptionId))
  add(path_568473, "relationName", newJString(relationName))
  add(path_568473, "workspaceName", newJString(workspaceName))
  add(path_568473, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var bookmarkRelationsDeleteRelation* = Call_BookmarkRelationsDeleteRelation_568461(
    name: "bookmarkRelationsDeleteRelation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/bookmarks/{bookmarkId}/relations/{relationName}",
    validator: validate_BookmarkRelationsDeleteRelation_568462, base: "",
    url: url_BookmarkRelationsDeleteRelation_568463, schemes: {Scheme.Https})
type
  Call_CasesList_568475 = ref object of OpenApiRestCall_567667
proc url_CasesList_568477(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CasesList_568476(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all cases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568478 = path.getOrDefault("resourceGroupName")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "resourceGroupName", valid_568478
  var valid_568479 = path.getOrDefault("subscriptionId")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "subscriptionId", valid_568479
  var valid_568480 = path.getOrDefault("workspaceName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "workspaceName", valid_568480
  var valid_568481 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "operationalInsightsResourceProvider", valid_568481
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_568482 = query.getOrDefault("$orderby")
  valid_568482 = validateParameter(valid_568482, JString, required = false,
                                 default = nil)
  if valid_568482 != nil:
    section.add "$orderby", valid_568482
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568483 = query.getOrDefault("api-version")
  valid_568483 = validateParameter(valid_568483, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568483 != nil:
    section.add "api-version", valid_568483
  var valid_568484 = query.getOrDefault("$top")
  valid_568484 = validateParameter(valid_568484, JInt, required = false, default = nil)
  if valid_568484 != nil:
    section.add "$top", valid_568484
  var valid_568485 = query.getOrDefault("$skipToken")
  valid_568485 = validateParameter(valid_568485, JString, required = false,
                                 default = nil)
  if valid_568485 != nil:
    section.add "$skipToken", valid_568485
  var valid_568486 = query.getOrDefault("$filter")
  valid_568486 = validateParameter(valid_568486, JString, required = false,
                                 default = nil)
  if valid_568486 != nil:
    section.add "$filter", valid_568486
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568487: Call_CasesList_568475; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all cases.
  ## 
  let valid = call_568487.validator(path, query, header, formData, body)
  let scheme = call_568487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568487.url(scheme.get, call_568487.host, call_568487.base,
                         call_568487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568487, url, valid)

proc call*(call_568488: Call_CasesList_568475; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; Orderby: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## casesList
  ## Gets all cases.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568489 = newJObject()
  var query_568490 = newJObject()
  add(query_568490, "$orderby", newJString(Orderby))
  add(path_568489, "resourceGroupName", newJString(resourceGroupName))
  add(query_568490, "api-version", newJString(apiVersion))
  add(path_568489, "subscriptionId", newJString(subscriptionId))
  add(query_568490, "$top", newJInt(Top))
  add(query_568490, "$skipToken", newJString(SkipToken))
  add(path_568489, "workspaceName", newJString(workspaceName))
  add(query_568490, "$filter", newJString(Filter))
  add(path_568489, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568488.call(path_568489, query_568490, nil, nil, nil)

var casesList* = Call_CasesList_568475(name: "casesList", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases",
                                    validator: validate_CasesList_568476,
                                    base: "", url: url_CasesList_568477,
                                    schemes: {Scheme.Https})
type
  Call_CasesCreateOrUpdate_568504 = ref object of OpenApiRestCall_567667
proc url_CasesCreateOrUpdate_568506(protocol: Scheme; host: string; base: string;
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

proc validate_CasesCreateOrUpdate_568505(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates or updates the case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568507 = path.getOrDefault("resourceGroupName")
  valid_568507 = validateParameter(valid_568507, JString, required = true,
                                 default = nil)
  if valid_568507 != nil:
    section.add "resourceGroupName", valid_568507
  var valid_568508 = path.getOrDefault("caseId")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = nil)
  if valid_568508 != nil:
    section.add "caseId", valid_568508
  var valid_568509 = path.getOrDefault("subscriptionId")
  valid_568509 = validateParameter(valid_568509, JString, required = true,
                                 default = nil)
  if valid_568509 != nil:
    section.add "subscriptionId", valid_568509
  var valid_568510 = path.getOrDefault("workspaceName")
  valid_568510 = validateParameter(valid_568510, JString, required = true,
                                 default = nil)
  if valid_568510 != nil:
    section.add "workspaceName", valid_568510
  var valid_568511 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568511 = validateParameter(valid_568511, JString, required = true,
                                 default = nil)
  if valid_568511 != nil:
    section.add "operationalInsightsResourceProvider", valid_568511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568512 = query.getOrDefault("api-version")
  valid_568512 = validateParameter(valid_568512, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568512 != nil:
    section.add "api-version", valid_568512
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

proc call*(call_568514: Call_CasesCreateOrUpdate_568504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the case.
  ## 
  let valid = call_568514.validator(path, query, header, formData, body)
  let scheme = call_568514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568514.url(scheme.get, call_568514.host, call_568514.base,
                         call_568514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568514, url, valid)

proc call*(call_568515: Call_CasesCreateOrUpdate_568504; resourceGroupName: string;
          `case`: JsonNode; caseId: string; subscriptionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesCreateOrUpdate
  ## Creates or updates the case.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   case: JObject (required)
  ##       : The case
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568516 = newJObject()
  var query_568517 = newJObject()
  var body_568518 = newJObject()
  add(path_568516, "resourceGroupName", newJString(resourceGroupName))
  add(query_568517, "api-version", newJString(apiVersion))
  if `case` != nil:
    body_568518 = `case`
  add(path_568516, "caseId", newJString(caseId))
  add(path_568516, "subscriptionId", newJString(subscriptionId))
  add(path_568516, "workspaceName", newJString(workspaceName))
  add(path_568516, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568515.call(path_568516, query_568517, nil, nil, body_568518)

var casesCreateOrUpdate* = Call_CasesCreateOrUpdate_568504(
    name: "casesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
    validator: validate_CasesCreateOrUpdate_568505, base: "",
    url: url_CasesCreateOrUpdate_568506, schemes: {Scheme.Https})
type
  Call_CasesGet_568491 = ref object of OpenApiRestCall_567667
proc url_CasesGet_568493(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_CasesGet_568492(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568494 = path.getOrDefault("resourceGroupName")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "resourceGroupName", valid_568494
  var valid_568495 = path.getOrDefault("caseId")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "caseId", valid_568495
  var valid_568496 = path.getOrDefault("subscriptionId")
  valid_568496 = validateParameter(valid_568496, JString, required = true,
                                 default = nil)
  if valid_568496 != nil:
    section.add "subscriptionId", valid_568496
  var valid_568497 = path.getOrDefault("workspaceName")
  valid_568497 = validateParameter(valid_568497, JString, required = true,
                                 default = nil)
  if valid_568497 != nil:
    section.add "workspaceName", valid_568497
  var valid_568498 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568498 = validateParameter(valid_568498, JString, required = true,
                                 default = nil)
  if valid_568498 != nil:
    section.add "operationalInsightsResourceProvider", valid_568498
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568499 = query.getOrDefault("api-version")
  valid_568499 = validateParameter(valid_568499, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568499 != nil:
    section.add "api-version", valid_568499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568500: Call_CasesGet_568491; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case.
  ## 
  let valid = call_568500.validator(path, query, header, formData, body)
  let scheme = call_568500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568500.url(scheme.get, call_568500.host, call_568500.base,
                         call_568500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568500, url, valid)

proc call*(call_568501: Call_CasesGet_568491; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesGet
  ## Gets a case.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568502 = newJObject()
  var query_568503 = newJObject()
  add(path_568502, "resourceGroupName", newJString(resourceGroupName))
  add(query_568503, "api-version", newJString(apiVersion))
  add(path_568502, "caseId", newJString(caseId))
  add(path_568502, "subscriptionId", newJString(subscriptionId))
  add(path_568502, "workspaceName", newJString(workspaceName))
  add(path_568502, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568501.call(path_568502, query_568503, nil, nil, nil)

var casesGet* = Call_CasesGet_568491(name: "casesGet", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
                                  validator: validate_CasesGet_568492, base: "",
                                  url: url_CasesGet_568493,
                                  schemes: {Scheme.Https})
type
  Call_CasesDelete_568519 = ref object of OpenApiRestCall_567667
proc url_CasesDelete_568521(protocol: Scheme; host: string; base: string;
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

proc validate_CasesDelete_568520(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the case.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568522 = path.getOrDefault("resourceGroupName")
  valid_568522 = validateParameter(valid_568522, JString, required = true,
                                 default = nil)
  if valid_568522 != nil:
    section.add "resourceGroupName", valid_568522
  var valid_568523 = path.getOrDefault("caseId")
  valid_568523 = validateParameter(valid_568523, JString, required = true,
                                 default = nil)
  if valid_568523 != nil:
    section.add "caseId", valid_568523
  var valid_568524 = path.getOrDefault("subscriptionId")
  valid_568524 = validateParameter(valid_568524, JString, required = true,
                                 default = nil)
  if valid_568524 != nil:
    section.add "subscriptionId", valid_568524
  var valid_568525 = path.getOrDefault("workspaceName")
  valid_568525 = validateParameter(valid_568525, JString, required = true,
                                 default = nil)
  if valid_568525 != nil:
    section.add "workspaceName", valid_568525
  var valid_568526 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568526 = validateParameter(valid_568526, JString, required = true,
                                 default = nil)
  if valid_568526 != nil:
    section.add "operationalInsightsResourceProvider", valid_568526
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568527 = query.getOrDefault("api-version")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568527 != nil:
    section.add "api-version", valid_568527
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568528: Call_CasesDelete_568519; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the case.
  ## 
  let valid = call_568528.validator(path, query, header, formData, body)
  let scheme = call_568528.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568528.url(scheme.get, call_568528.host, call_568528.base,
                         call_568528.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568528, url, valid)

proc call*(call_568529: Call_CasesDelete_568519; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesDelete
  ## Delete the case.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568530 = newJObject()
  var query_568531 = newJObject()
  add(path_568530, "resourceGroupName", newJString(resourceGroupName))
  add(query_568531, "api-version", newJString(apiVersion))
  add(path_568530, "caseId", newJString(caseId))
  add(path_568530, "subscriptionId", newJString(subscriptionId))
  add(path_568530, "workspaceName", newJString(workspaceName))
  add(path_568530, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568529.call(path_568530, query_568531, nil, nil, nil)

var casesDelete* = Call_CasesDelete_568519(name: "casesDelete",
                                        meth: HttpMethod.HttpDelete,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}",
                                        validator: validate_CasesDelete_568520,
                                        base: "", url: url_CasesDelete_568521,
                                        schemes: {Scheme.Https})
type
  Call_CommentsListByCase_568532 = ref object of OpenApiRestCall_567667
proc url_CommentsListByCase_568534(protocol: Scheme; host: string; base: string;
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

proc validate_CommentsListByCase_568533(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all case comments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568535 = path.getOrDefault("resourceGroupName")
  valid_568535 = validateParameter(valid_568535, JString, required = true,
                                 default = nil)
  if valid_568535 != nil:
    section.add "resourceGroupName", valid_568535
  var valid_568536 = path.getOrDefault("caseId")
  valid_568536 = validateParameter(valid_568536, JString, required = true,
                                 default = nil)
  if valid_568536 != nil:
    section.add "caseId", valid_568536
  var valid_568537 = path.getOrDefault("subscriptionId")
  valid_568537 = validateParameter(valid_568537, JString, required = true,
                                 default = nil)
  if valid_568537 != nil:
    section.add "subscriptionId", valid_568537
  var valid_568538 = path.getOrDefault("workspaceName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "workspaceName", valid_568538
  var valid_568539 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "operationalInsightsResourceProvider", valid_568539
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_568540 = query.getOrDefault("$orderby")
  valid_568540 = validateParameter(valid_568540, JString, required = false,
                                 default = nil)
  if valid_568540 != nil:
    section.add "$orderby", valid_568540
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568541 = query.getOrDefault("api-version")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568541 != nil:
    section.add "api-version", valid_568541
  var valid_568542 = query.getOrDefault("$top")
  valid_568542 = validateParameter(valid_568542, JInt, required = false, default = nil)
  if valid_568542 != nil:
    section.add "$top", valid_568542
  var valid_568543 = query.getOrDefault("$skipToken")
  valid_568543 = validateParameter(valid_568543, JString, required = false,
                                 default = nil)
  if valid_568543 != nil:
    section.add "$skipToken", valid_568543
  var valid_568544 = query.getOrDefault("$filter")
  valid_568544 = validateParameter(valid_568544, JString, required = false,
                                 default = nil)
  if valid_568544 != nil:
    section.add "$filter", valid_568544
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568545: Call_CommentsListByCase_568532; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all case comments.
  ## 
  let valid = call_568545.validator(path, query, header, formData, body)
  let scheme = call_568545.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568545.url(scheme.get, call_568545.host, call_568545.base,
                         call_568545.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568545, url, valid)

proc call*(call_568546: Call_CommentsListByCase_568532; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; Orderby: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## commentsListByCase
  ## Gets all case comments.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568547 = newJObject()
  var query_568548 = newJObject()
  add(query_568548, "$orderby", newJString(Orderby))
  add(path_568547, "resourceGroupName", newJString(resourceGroupName))
  add(query_568548, "api-version", newJString(apiVersion))
  add(path_568547, "caseId", newJString(caseId))
  add(path_568547, "subscriptionId", newJString(subscriptionId))
  add(query_568548, "$top", newJInt(Top))
  add(query_568548, "$skipToken", newJString(SkipToken))
  add(path_568547, "workspaceName", newJString(workspaceName))
  add(query_568548, "$filter", newJString(Filter))
  add(path_568547, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568546.call(path_568547, query_568548, nil, nil, nil)

var commentsListByCase* = Call_CommentsListByCase_568532(
    name: "commentsListByCase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments",
    validator: validate_CommentsListByCase_568533, base: "",
    url: url_CommentsListByCase_568534, schemes: {Scheme.Https})
type
  Call_CaseCommentsCreateComment_568563 = ref object of OpenApiRestCall_567667
proc url_CaseCommentsCreateComment_568565(protocol: Scheme; host: string;
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

proc validate_CaseCommentsCreateComment_568564(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the case comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseCommentId: JString (required)
  ##                : Case comment ID
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568566 = path.getOrDefault("resourceGroupName")
  valid_568566 = validateParameter(valid_568566, JString, required = true,
                                 default = nil)
  if valid_568566 != nil:
    section.add "resourceGroupName", valid_568566
  var valid_568567 = path.getOrDefault("caseCommentId")
  valid_568567 = validateParameter(valid_568567, JString, required = true,
                                 default = nil)
  if valid_568567 != nil:
    section.add "caseCommentId", valid_568567
  var valid_568568 = path.getOrDefault("caseId")
  valid_568568 = validateParameter(valid_568568, JString, required = true,
                                 default = nil)
  if valid_568568 != nil:
    section.add "caseId", valid_568568
  var valid_568569 = path.getOrDefault("subscriptionId")
  valid_568569 = validateParameter(valid_568569, JString, required = true,
                                 default = nil)
  if valid_568569 != nil:
    section.add "subscriptionId", valid_568569
  var valid_568570 = path.getOrDefault("workspaceName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "workspaceName", valid_568570
  var valid_568571 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "operationalInsightsResourceProvider", valid_568571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568572 = query.getOrDefault("api-version")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568572 != nil:
    section.add "api-version", valid_568572
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

proc call*(call_568574: Call_CaseCommentsCreateComment_568563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the case comment.
  ## 
  let valid = call_568574.validator(path, query, header, formData, body)
  let scheme = call_568574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568574.url(scheme.get, call_568574.host, call_568574.base,
                         call_568574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568574, url, valid)

proc call*(call_568575: Call_CaseCommentsCreateComment_568563;
          resourceGroupName: string; caseCommentId: string; caseId: string;
          subscriptionId: string; caseComment: JsonNode; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseCommentsCreateComment
  ## Creates the case comment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseCommentId: string (required)
  ##                : Case comment ID
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   caseComment: JObject (required)
  ##              : The case comment
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568576 = newJObject()
  var query_568577 = newJObject()
  var body_568578 = newJObject()
  add(path_568576, "resourceGroupName", newJString(resourceGroupName))
  add(query_568577, "api-version", newJString(apiVersion))
  add(path_568576, "caseCommentId", newJString(caseCommentId))
  add(path_568576, "caseId", newJString(caseId))
  add(path_568576, "subscriptionId", newJString(subscriptionId))
  if caseComment != nil:
    body_568578 = caseComment
  add(path_568576, "workspaceName", newJString(workspaceName))
  add(path_568576, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568575.call(path_568576, query_568577, nil, nil, body_568578)

var caseCommentsCreateComment* = Call_CaseCommentsCreateComment_568563(
    name: "caseCommentsCreateComment", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments/{caseCommentId}",
    validator: validate_CaseCommentsCreateComment_568564, base: "",
    url: url_CaseCommentsCreateComment_568565, schemes: {Scheme.Https})
type
  Call_CasesGetComment_568549 = ref object of OpenApiRestCall_567667
proc url_CasesGetComment_568551(protocol: Scheme; host: string; base: string;
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

proc validate_CasesGetComment_568550(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets a case comment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseCommentId: JString (required)
  ##                : Case comment ID
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568552 = path.getOrDefault("resourceGroupName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "resourceGroupName", valid_568552
  var valid_568553 = path.getOrDefault("caseCommentId")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "caseCommentId", valid_568553
  var valid_568554 = path.getOrDefault("caseId")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "caseId", valid_568554
  var valid_568555 = path.getOrDefault("subscriptionId")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = nil)
  if valid_568555 != nil:
    section.add "subscriptionId", valid_568555
  var valid_568556 = path.getOrDefault("workspaceName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "workspaceName", valid_568556
  var valid_568557 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "operationalInsightsResourceProvider", valid_568557
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568558 = query.getOrDefault("api-version")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568558 != nil:
    section.add "api-version", valid_568558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568559: Call_CasesGetComment_568549; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case comment.
  ## 
  let valid = call_568559.validator(path, query, header, formData, body)
  let scheme = call_568559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568559.url(scheme.get, call_568559.host, call_568559.base,
                         call_568559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568559, url, valid)

proc call*(call_568560: Call_CasesGetComment_568549; resourceGroupName: string;
          caseCommentId: string; caseId: string; subscriptionId: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## casesGetComment
  ## Gets a case comment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseCommentId: string (required)
  ##                : Case comment ID
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568561 = newJObject()
  var query_568562 = newJObject()
  add(path_568561, "resourceGroupName", newJString(resourceGroupName))
  add(query_568562, "api-version", newJString(apiVersion))
  add(path_568561, "caseCommentId", newJString(caseCommentId))
  add(path_568561, "caseId", newJString(caseId))
  add(path_568561, "subscriptionId", newJString(subscriptionId))
  add(path_568561, "workspaceName", newJString(workspaceName))
  add(path_568561, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568560.call(path_568561, query_568562, nil, nil, nil)

var casesGetComment* = Call_CasesGetComment_568549(name: "casesGetComment",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/comments/{caseCommentId}",
    validator: validate_CasesGetComment_568550, base: "", url: url_CasesGetComment_568551,
    schemes: {Scheme.Https})
type
  Call_CaseRelationsList_568579 = ref object of OpenApiRestCall_567667
proc url_CaseRelationsList_568581(protocol: Scheme; host: string; base: string;
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

proc validate_CaseRelationsList_568580(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all case relations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568582 = path.getOrDefault("resourceGroupName")
  valid_568582 = validateParameter(valid_568582, JString, required = true,
                                 default = nil)
  if valid_568582 != nil:
    section.add "resourceGroupName", valid_568582
  var valid_568583 = path.getOrDefault("caseId")
  valid_568583 = validateParameter(valid_568583, JString, required = true,
                                 default = nil)
  if valid_568583 != nil:
    section.add "caseId", valid_568583
  var valid_568584 = path.getOrDefault("subscriptionId")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "subscriptionId", valid_568584
  var valid_568585 = path.getOrDefault("workspaceName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "workspaceName", valid_568585
  var valid_568586 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "operationalInsightsResourceProvider", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sorts the results. Optional.
  ##   api-version: JString (required)
  ##              : API version for the operation
  ##   $top: JInt
  ##       : Returns only the first n results. Optional.
  ##   $skipToken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   $filter: JString
  ##          : Filters the results, based on a Boolean condition. Optional.
  section = newJObject()
  var valid_568587 = query.getOrDefault("$orderby")
  valid_568587 = validateParameter(valid_568587, JString, required = false,
                                 default = nil)
  if valid_568587 != nil:
    section.add "$orderby", valid_568587
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568588 = query.getOrDefault("api-version")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568588 != nil:
    section.add "api-version", valid_568588
  var valid_568589 = query.getOrDefault("$top")
  valid_568589 = validateParameter(valid_568589, JInt, required = false, default = nil)
  if valid_568589 != nil:
    section.add "$top", valid_568589
  var valid_568590 = query.getOrDefault("$skipToken")
  valid_568590 = validateParameter(valid_568590, JString, required = false,
                                 default = nil)
  if valid_568590 != nil:
    section.add "$skipToken", valid_568590
  var valid_568591 = query.getOrDefault("$filter")
  valid_568591 = validateParameter(valid_568591, JString, required = false,
                                 default = nil)
  if valid_568591 != nil:
    section.add "$filter", valid_568591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568592: Call_CaseRelationsList_568579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all case relations.
  ## 
  let valid = call_568592.validator(path, query, header, formData, body)
  let scheme = call_568592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568592.url(scheme.get, call_568592.host, call_568592.base,
                         call_568592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568592, url, valid)

proc call*(call_568593: Call_CaseRelationsList_568579; resourceGroupName: string;
          caseId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; Orderby: string = "";
          apiVersion: string = "2019-01-01-preview"; Top: int = 0;
          SkipToken: string = ""; Filter: string = ""): Recallable =
  ## caseRelationsList
  ## Gets all case relations.
  ##   Orderby: string
  ##          : Sorts the results. Optional.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   Top: int
  ##      : Returns only the first n results. Optional.
  ##   SkipToken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls. Optional.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   Filter: string
  ##         : Filters the results, based on a Boolean condition. Optional.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568594 = newJObject()
  var query_568595 = newJObject()
  add(query_568595, "$orderby", newJString(Orderby))
  add(path_568594, "resourceGroupName", newJString(resourceGroupName))
  add(query_568595, "api-version", newJString(apiVersion))
  add(path_568594, "caseId", newJString(caseId))
  add(path_568594, "subscriptionId", newJString(subscriptionId))
  add(query_568595, "$top", newJInt(Top))
  add(query_568595, "$skipToken", newJString(SkipToken))
  add(path_568594, "workspaceName", newJString(workspaceName))
  add(query_568595, "$filter", newJString(Filter))
  add(path_568594, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568593.call(path_568594, query_568595, nil, nil, nil)

var caseRelationsList* = Call_CaseRelationsList_568579(name: "caseRelationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations",
    validator: validate_CaseRelationsList_568580, base: "",
    url: url_CaseRelationsList_568581, schemes: {Scheme.Https})
type
  Call_CaseRelationsCreateOrUpdateRelation_568610 = ref object of OpenApiRestCall_567667
proc url_CaseRelationsCreateOrUpdateRelation_568612(protocol: Scheme; host: string;
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

proc validate_CaseRelationsCreateOrUpdateRelation_568611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568613 = path.getOrDefault("resourceGroupName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "resourceGroupName", valid_568613
  var valid_568614 = path.getOrDefault("caseId")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "caseId", valid_568614
  var valid_568615 = path.getOrDefault("subscriptionId")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "subscriptionId", valid_568615
  var valid_568616 = path.getOrDefault("relationName")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "relationName", valid_568616
  var valid_568617 = path.getOrDefault("workspaceName")
  valid_568617 = validateParameter(valid_568617, JString, required = true,
                                 default = nil)
  if valid_568617 != nil:
    section.add "workspaceName", valid_568617
  var valid_568618 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568618 = validateParameter(valid_568618, JString, required = true,
                                 default = nil)
  if valid_568618 != nil:
    section.add "operationalInsightsResourceProvider", valid_568618
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568619 = query.getOrDefault("api-version")
  valid_568619 = validateParameter(valid_568619, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568619 != nil:
    section.add "api-version", valid_568619
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

proc call*(call_568621: Call_CaseRelationsCreateOrUpdateRelation_568610;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the case relation.
  ## 
  let valid = call_568621.validator(path, query, header, formData, body)
  let scheme = call_568621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568621.url(scheme.get, call_568621.host, call_568621.base,
                         call_568621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568621, url, valid)

proc call*(call_568622: Call_CaseRelationsCreateOrUpdateRelation_568610;
          resourceGroupName: string; caseId: string; relationInputModel: JsonNode;
          subscriptionId: string; relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsCreateOrUpdateRelation
  ## Creates or updates the case relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   relationInputModel: JObject (required)
  ##                     : The relation input model
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568623 = newJObject()
  var query_568624 = newJObject()
  var body_568625 = newJObject()
  add(path_568623, "resourceGroupName", newJString(resourceGroupName))
  add(query_568624, "api-version", newJString(apiVersion))
  add(path_568623, "caseId", newJString(caseId))
  if relationInputModel != nil:
    body_568625 = relationInputModel
  add(path_568623, "subscriptionId", newJString(subscriptionId))
  add(path_568623, "relationName", newJString(relationName))
  add(path_568623, "workspaceName", newJString(workspaceName))
  add(path_568623, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568622.call(path_568623, query_568624, nil, nil, body_568625)

var caseRelationsCreateOrUpdateRelation* = Call_CaseRelationsCreateOrUpdateRelation_568610(
    name: "caseRelationsCreateOrUpdateRelation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsCreateOrUpdateRelation_568611, base: "",
    url: url_CaseRelationsCreateOrUpdateRelation_568612, schemes: {Scheme.Https})
type
  Call_CaseRelationsGetRelation_568596 = ref object of OpenApiRestCall_567667
proc url_CaseRelationsGetRelation_568598(protocol: Scheme; host: string;
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

proc validate_CaseRelationsGetRelation_568597(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568599 = path.getOrDefault("resourceGroupName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "resourceGroupName", valid_568599
  var valid_568600 = path.getOrDefault("caseId")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "caseId", valid_568600
  var valid_568601 = path.getOrDefault("subscriptionId")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "subscriptionId", valid_568601
  var valid_568602 = path.getOrDefault("relationName")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "relationName", valid_568602
  var valid_568603 = path.getOrDefault("workspaceName")
  valid_568603 = validateParameter(valid_568603, JString, required = true,
                                 default = nil)
  if valid_568603 != nil:
    section.add "workspaceName", valid_568603
  var valid_568604 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568604 = validateParameter(valid_568604, JString, required = true,
                                 default = nil)
  if valid_568604 != nil:
    section.add "operationalInsightsResourceProvider", valid_568604
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568605 = query.getOrDefault("api-version")
  valid_568605 = validateParameter(valid_568605, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568605 != nil:
    section.add "api-version", valid_568605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568606: Call_CaseRelationsGetRelation_568596; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a case relation.
  ## 
  let valid = call_568606.validator(path, query, header, formData, body)
  let scheme = call_568606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568606.url(scheme.get, call_568606.host, call_568606.base,
                         call_568606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568606, url, valid)

proc call*(call_568607: Call_CaseRelationsGetRelation_568596;
          resourceGroupName: string; caseId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsGetRelation
  ## Gets a case relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568608 = newJObject()
  var query_568609 = newJObject()
  add(path_568608, "resourceGroupName", newJString(resourceGroupName))
  add(query_568609, "api-version", newJString(apiVersion))
  add(path_568608, "caseId", newJString(caseId))
  add(path_568608, "subscriptionId", newJString(subscriptionId))
  add(path_568608, "relationName", newJString(relationName))
  add(path_568608, "workspaceName", newJString(workspaceName))
  add(path_568608, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568607.call(path_568608, query_568609, nil, nil, nil)

var caseRelationsGetRelation* = Call_CaseRelationsGetRelation_568596(
    name: "caseRelationsGetRelation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsGetRelation_568597, base: "",
    url: url_CaseRelationsGetRelation_568598, schemes: {Scheme.Https})
type
  Call_CaseRelationsDeleteRelation_568626 = ref object of OpenApiRestCall_567667
proc url_CaseRelationsDeleteRelation_568628(protocol: Scheme; host: string;
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

proc validate_CaseRelationsDeleteRelation_568627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the case relation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   caseId: JString (required)
  ##         : Case ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   relationName: JString (required)
  ##               : Relation Name
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568629 = path.getOrDefault("resourceGroupName")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "resourceGroupName", valid_568629
  var valid_568630 = path.getOrDefault("caseId")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "caseId", valid_568630
  var valid_568631 = path.getOrDefault("subscriptionId")
  valid_568631 = validateParameter(valid_568631, JString, required = true,
                                 default = nil)
  if valid_568631 != nil:
    section.add "subscriptionId", valid_568631
  var valid_568632 = path.getOrDefault("relationName")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = nil)
  if valid_568632 != nil:
    section.add "relationName", valid_568632
  var valid_568633 = path.getOrDefault("workspaceName")
  valid_568633 = validateParameter(valid_568633, JString, required = true,
                                 default = nil)
  if valid_568633 != nil:
    section.add "workspaceName", valid_568633
  var valid_568634 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568634 = validateParameter(valid_568634, JString, required = true,
                                 default = nil)
  if valid_568634 != nil:
    section.add "operationalInsightsResourceProvider", valid_568634
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568635 = query.getOrDefault("api-version")
  valid_568635 = validateParameter(valid_568635, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568635 != nil:
    section.add "api-version", valid_568635
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568636: Call_CaseRelationsDeleteRelation_568626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the case relation.
  ## 
  let valid = call_568636.validator(path, query, header, formData, body)
  let scheme = call_568636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568636.url(scheme.get, call_568636.host, call_568636.base,
                         call_568636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568636, url, valid)

proc call*(call_568637: Call_CaseRelationsDeleteRelation_568626;
          resourceGroupName: string; caseId: string; subscriptionId: string;
          relationName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## caseRelationsDeleteRelation
  ## Delete the case relation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   caseId: string (required)
  ##         : Case ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   relationName: string (required)
  ##               : Relation Name
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568638 = newJObject()
  var query_568639 = newJObject()
  add(path_568638, "resourceGroupName", newJString(resourceGroupName))
  add(query_568639, "api-version", newJString(apiVersion))
  add(path_568638, "caseId", newJString(caseId))
  add(path_568638, "subscriptionId", newJString(subscriptionId))
  add(path_568638, "relationName", newJString(relationName))
  add(path_568638, "workspaceName", newJString(workspaceName))
  add(path_568638, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568637.call(path_568638, query_568639, nil, nil, nil)

var caseRelationsDeleteRelation* = Call_CaseRelationsDeleteRelation_568626(
    name: "caseRelationsDeleteRelation", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/cases/{caseId}/relations/{relationName}",
    validator: validate_CaseRelationsDeleteRelation_568627, base: "",
    url: url_CaseRelationsDeleteRelation_568628, schemes: {Scheme.Https})
type
  Call_DataConnectorsList_568640 = ref object of OpenApiRestCall_567667
proc url_DataConnectorsList_568642(protocol: Scheme; host: string; base: string;
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

proc validate_DataConnectorsList_568641(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all data connectors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568643 = path.getOrDefault("resourceGroupName")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "resourceGroupName", valid_568643
  var valid_568644 = path.getOrDefault("subscriptionId")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "subscriptionId", valid_568644
  var valid_568645 = path.getOrDefault("workspaceName")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "workspaceName", valid_568645
  var valid_568646 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568646 = validateParameter(valid_568646, JString, required = true,
                                 default = nil)
  if valid_568646 != nil:
    section.add "operationalInsightsResourceProvider", valid_568646
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568647 = query.getOrDefault("api-version")
  valid_568647 = validateParameter(valid_568647, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568647 != nil:
    section.add "api-version", valid_568647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568648: Call_DataConnectorsList_568640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all data connectors.
  ## 
  let valid = call_568648.validator(path, query, header, formData, body)
  let scheme = call_568648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568648.url(scheme.get, call_568648.host, call_568648.base,
                         call_568648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568648, url, valid)

proc call*(call_568649: Call_DataConnectorsList_568640; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsList
  ## Gets all data connectors.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568650 = newJObject()
  var query_568651 = newJObject()
  add(path_568650, "resourceGroupName", newJString(resourceGroupName))
  add(query_568651, "api-version", newJString(apiVersion))
  add(path_568650, "subscriptionId", newJString(subscriptionId))
  add(path_568650, "workspaceName", newJString(workspaceName))
  add(path_568650, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568649.call(path_568650, query_568651, nil, nil, nil)

var dataConnectorsList* = Call_DataConnectorsList_568640(
    name: "dataConnectorsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors",
    validator: validate_DataConnectorsList_568641, base: "",
    url: url_DataConnectorsList_568642, schemes: {Scheme.Https})
type
  Call_DataConnectorsCreateOrUpdate_568665 = ref object of OpenApiRestCall_567667
proc url_DataConnectorsCreateOrUpdate_568667(protocol: Scheme; host: string;
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

proc validate_DataConnectorsCreateOrUpdate_568666(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568668 = path.getOrDefault("resourceGroupName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "resourceGroupName", valid_568668
  var valid_568669 = path.getOrDefault("subscriptionId")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "subscriptionId", valid_568669
  var valid_568670 = path.getOrDefault("workspaceName")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "workspaceName", valid_568670
  var valid_568671 = path.getOrDefault("dataConnectorId")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "dataConnectorId", valid_568671
  var valid_568672 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "operationalInsightsResourceProvider", valid_568672
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568673 = query.getOrDefault("api-version")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568673 != nil:
    section.add "api-version", valid_568673
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

proc call*(call_568675: Call_DataConnectorsCreateOrUpdate_568665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the data connector.
  ## 
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_DataConnectorsCreateOrUpdate_568665;
          resourceGroupName: string; subscriptionId: string;
          dataConnector: JsonNode; workspaceName: string; dataConnectorId: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsCreateOrUpdate
  ## Creates or updates the data connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   dataConnector: JObject (required)
  ##                : The data connector
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568677 = newJObject()
  var query_568678 = newJObject()
  var body_568679 = newJObject()
  add(path_568677, "resourceGroupName", newJString(resourceGroupName))
  add(query_568678, "api-version", newJString(apiVersion))
  add(path_568677, "subscriptionId", newJString(subscriptionId))
  if dataConnector != nil:
    body_568679 = dataConnector
  add(path_568677, "workspaceName", newJString(workspaceName))
  add(path_568677, "dataConnectorId", newJString(dataConnectorId))
  add(path_568677, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568676.call(path_568677, query_568678, nil, nil, body_568679)

var dataConnectorsCreateOrUpdate* = Call_DataConnectorsCreateOrUpdate_568665(
    name: "dataConnectorsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsCreateOrUpdate_568666, base: "",
    url: url_DataConnectorsCreateOrUpdate_568667, schemes: {Scheme.Https})
type
  Call_DataConnectorsGet_568652 = ref object of OpenApiRestCall_567667
proc url_DataConnectorsGet_568654(protocol: Scheme; host: string; base: string;
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

proc validate_DataConnectorsGet_568653(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568655 = path.getOrDefault("resourceGroupName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "resourceGroupName", valid_568655
  var valid_568656 = path.getOrDefault("subscriptionId")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "subscriptionId", valid_568656
  var valid_568657 = path.getOrDefault("workspaceName")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "workspaceName", valid_568657
  var valid_568658 = path.getOrDefault("dataConnectorId")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "dataConnectorId", valid_568658
  var valid_568659 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568659 = validateParameter(valid_568659, JString, required = true,
                                 default = nil)
  if valid_568659 != nil:
    section.add "operationalInsightsResourceProvider", valid_568659
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568660 = query.getOrDefault("api-version")
  valid_568660 = validateParameter(valid_568660, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568660 != nil:
    section.add "api-version", valid_568660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568661: Call_DataConnectorsGet_568652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a data connector.
  ## 
  let valid = call_568661.validator(path, query, header, formData, body)
  let scheme = call_568661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568661.url(scheme.get, call_568661.host, call_568661.base,
                         call_568661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568661, url, valid)

proc call*(call_568662: Call_DataConnectorsGet_568652; resourceGroupName: string;
          subscriptionId: string; workspaceName: string; dataConnectorId: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsGet
  ## Gets a data connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568663 = newJObject()
  var query_568664 = newJObject()
  add(path_568663, "resourceGroupName", newJString(resourceGroupName))
  add(query_568664, "api-version", newJString(apiVersion))
  add(path_568663, "subscriptionId", newJString(subscriptionId))
  add(path_568663, "workspaceName", newJString(workspaceName))
  add(path_568663, "dataConnectorId", newJString(dataConnectorId))
  add(path_568663, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568662.call(path_568663, query_568664, nil, nil, nil)

var dataConnectorsGet* = Call_DataConnectorsGet_568652(name: "dataConnectorsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsGet_568653, base: "",
    url: url_DataConnectorsGet_568654, schemes: {Scheme.Https})
type
  Call_DataConnectorsDelete_568680 = ref object of OpenApiRestCall_567667
proc url_DataConnectorsDelete_568682(protocol: Scheme; host: string; base: string;
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

proc validate_DataConnectorsDelete_568681(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the data connector.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: JString (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568683 = path.getOrDefault("resourceGroupName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "resourceGroupName", valid_568683
  var valid_568684 = path.getOrDefault("subscriptionId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "subscriptionId", valid_568684
  var valid_568685 = path.getOrDefault("workspaceName")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "workspaceName", valid_568685
  var valid_568686 = path.getOrDefault("dataConnectorId")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "dataConnectorId", valid_568686
  var valid_568687 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "operationalInsightsResourceProvider", valid_568687
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568688 = query.getOrDefault("api-version")
  valid_568688 = validateParameter(valid_568688, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568688 != nil:
    section.add "api-version", valid_568688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568689: Call_DataConnectorsDelete_568680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the data connector.
  ## 
  let valid = call_568689.validator(path, query, header, formData, body)
  let scheme = call_568689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568689.url(scheme.get, call_568689.host, call_568689.base,
                         call_568689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568689, url, valid)

proc call*(call_568690: Call_DataConnectorsDelete_568680;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          dataConnectorId: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## dataConnectorsDelete
  ## Delete the data connector.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   dataConnectorId: string (required)
  ##                  : Connector ID
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568691 = newJObject()
  var query_568692 = newJObject()
  add(path_568691, "resourceGroupName", newJString(resourceGroupName))
  add(query_568692, "api-version", newJString(apiVersion))
  add(path_568691, "subscriptionId", newJString(subscriptionId))
  add(path_568691, "workspaceName", newJString(workspaceName))
  add(path_568691, "dataConnectorId", newJString(dataConnectorId))
  add(path_568691, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568690.call(path_568691, query_568692, nil, nil, nil)

var dataConnectorsDelete* = Call_DataConnectorsDelete_568680(
    name: "dataConnectorsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/dataConnectors/{dataConnectorId}",
    validator: validate_DataConnectorsDelete_568681, base: "",
    url: url_DataConnectorsDelete_568682, schemes: {Scheme.Https})
type
  Call_EntitiesList_568693 = ref object of OpenApiRestCall_567667
proc url_EntitiesList_568695(protocol: Scheme; host: string; base: string;
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

proc validate_EntitiesList_568694(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all entities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568696 = path.getOrDefault("resourceGroupName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "resourceGroupName", valid_568696
  var valid_568697 = path.getOrDefault("subscriptionId")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "subscriptionId", valid_568697
  var valid_568698 = path.getOrDefault("workspaceName")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "workspaceName", valid_568698
  var valid_568699 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "operationalInsightsResourceProvider", valid_568699
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568700 = query.getOrDefault("api-version")
  valid_568700 = validateParameter(valid_568700, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568700 != nil:
    section.add "api-version", valid_568700
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568701: Call_EntitiesList_568693; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all entities.
  ## 
  let valid = call_568701.validator(path, query, header, formData, body)
  let scheme = call_568701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568701.url(scheme.get, call_568701.host, call_568701.base,
                         call_568701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568701, url, valid)

proc call*(call_568702: Call_EntitiesList_568693; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesList
  ## Gets all entities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568703 = newJObject()
  var query_568704 = newJObject()
  add(path_568703, "resourceGroupName", newJString(resourceGroupName))
  add(query_568704, "api-version", newJString(apiVersion))
  add(path_568703, "subscriptionId", newJString(subscriptionId))
  add(path_568703, "workspaceName", newJString(workspaceName))
  add(path_568703, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568702.call(path_568703, query_568704, nil, nil, nil)

var entitiesList* = Call_EntitiesList_568693(name: "entitiesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities",
    validator: validate_EntitiesList_568694, base: "", url: url_EntitiesList_568695,
    schemes: {Scheme.Https})
type
  Call_EntitiesGet_568705 = ref object of OpenApiRestCall_567667
proc url_EntitiesGet_568707(protocol: Scheme; host: string; base: string;
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

proc validate_EntitiesGet_568706(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   entityId: JString (required)
  ##           : entity ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568708 = path.getOrDefault("resourceGroupName")
  valid_568708 = validateParameter(valid_568708, JString, required = true,
                                 default = nil)
  if valid_568708 != nil:
    section.add "resourceGroupName", valid_568708
  var valid_568709 = path.getOrDefault("entityId")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "entityId", valid_568709
  var valid_568710 = path.getOrDefault("subscriptionId")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "subscriptionId", valid_568710
  var valid_568711 = path.getOrDefault("workspaceName")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "workspaceName", valid_568711
  var valid_568712 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "operationalInsightsResourceProvider", valid_568712
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568713 = query.getOrDefault("api-version")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568713 != nil:
    section.add "api-version", valid_568713
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568714: Call_EntitiesGet_568705; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an entity.
  ## 
  let valid = call_568714.validator(path, query, header, formData, body)
  let scheme = call_568714.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568714.url(scheme.get, call_568714.host, call_568714.base,
                         call_568714.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568714, url, valid)

proc call*(call_568715: Call_EntitiesGet_568705; resourceGroupName: string;
          entityId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesGet
  ## Gets an entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityId: string (required)
  ##           : entity ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568716 = newJObject()
  var query_568717 = newJObject()
  add(path_568716, "resourceGroupName", newJString(resourceGroupName))
  add(query_568717, "api-version", newJString(apiVersion))
  add(path_568716, "entityId", newJString(entityId))
  add(path_568716, "subscriptionId", newJString(subscriptionId))
  add(path_568716, "workspaceName", newJString(workspaceName))
  add(path_568716, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568715.call(path_568716, query_568717, nil, nil, nil)

var entitiesGet* = Call_EntitiesGet_568705(name: "entitiesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities/{entityId}",
                                        validator: validate_EntitiesGet_568706,
                                        base: "", url: url_EntitiesGet_568707,
                                        schemes: {Scheme.Https})
type
  Call_EntitiesExpand_568718 = ref object of OpenApiRestCall_567667
proc url_EntitiesExpand_568720(protocol: Scheme; host: string; base: string;
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

proc validate_EntitiesExpand_568719(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Expands an entity.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   entityId: JString (required)
  ##           : entity ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568738 = path.getOrDefault("resourceGroupName")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "resourceGroupName", valid_568738
  var valid_568739 = path.getOrDefault("entityId")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "entityId", valid_568739
  var valid_568740 = path.getOrDefault("subscriptionId")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "subscriptionId", valid_568740
  var valid_568741 = path.getOrDefault("workspaceName")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "workspaceName", valid_568741
  var valid_568742 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "operationalInsightsResourceProvider", valid_568742
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568743 = query.getOrDefault("api-version")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568743 != nil:
    section.add "api-version", valid_568743
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

proc call*(call_568745: Call_EntitiesExpand_568718; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Expands an entity.
  ## 
  let valid = call_568745.validator(path, query, header, formData, body)
  let scheme = call_568745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568745.url(scheme.get, call_568745.host, call_568745.base,
                         call_568745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568745, url, valid)

proc call*(call_568746: Call_EntitiesExpand_568718; resourceGroupName: string;
          entityId: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entitiesExpand
  ## Expands an entity.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityId: string (required)
  ##           : entity ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   parameters: JObject (required)
  ##             : The parameters required to execute an expand operation on the given entity.
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568747 = newJObject()
  var query_568748 = newJObject()
  var body_568749 = newJObject()
  add(path_568747, "resourceGroupName", newJString(resourceGroupName))
  add(query_568748, "api-version", newJString(apiVersion))
  add(path_568747, "entityId", newJString(entityId))
  add(path_568747, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568749 = parameters
  add(path_568747, "workspaceName", newJString(workspaceName))
  add(path_568747, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568746.call(path_568747, query_568748, nil, nil, body_568749)

var entitiesExpand* = Call_EntitiesExpand_568718(name: "entitiesExpand",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entities/{entityId}/expand",
    validator: validate_EntitiesExpand_568719, base: "", url: url_EntitiesExpand_568720,
    schemes: {Scheme.Https})
type
  Call_EntityQueriesList_568750 = ref object of OpenApiRestCall_567667
proc url_EntityQueriesList_568752(protocol: Scheme; host: string; base: string;
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

proc validate_EntityQueriesList_568751(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets all entity queries.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568753 = path.getOrDefault("resourceGroupName")
  valid_568753 = validateParameter(valid_568753, JString, required = true,
                                 default = nil)
  if valid_568753 != nil:
    section.add "resourceGroupName", valid_568753
  var valid_568754 = path.getOrDefault("subscriptionId")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "subscriptionId", valid_568754
  var valid_568755 = path.getOrDefault("workspaceName")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "workspaceName", valid_568755
  var valid_568756 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "operationalInsightsResourceProvider", valid_568756
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568757 = query.getOrDefault("api-version")
  valid_568757 = validateParameter(valid_568757, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568757 != nil:
    section.add "api-version", valid_568757
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568758: Call_EntityQueriesList_568750; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all entity queries.
  ## 
  let valid = call_568758.validator(path, query, header, formData, body)
  let scheme = call_568758.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568758.url(scheme.get, call_568758.host, call_568758.base,
                         call_568758.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568758, url, valid)

proc call*(call_568759: Call_EntityQueriesList_568750; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entityQueriesList
  ## Gets all entity queries.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568760 = newJObject()
  var query_568761 = newJObject()
  add(path_568760, "resourceGroupName", newJString(resourceGroupName))
  add(query_568761, "api-version", newJString(apiVersion))
  add(path_568760, "subscriptionId", newJString(subscriptionId))
  add(path_568760, "workspaceName", newJString(workspaceName))
  add(path_568760, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568759.call(path_568760, query_568761, nil, nil, nil)

var entityQueriesList* = Call_EntityQueriesList_568750(name: "entityQueriesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entityQueries",
    validator: validate_EntityQueriesList_568751, base: "",
    url: url_EntityQueriesList_568752, schemes: {Scheme.Https})
type
  Call_EntityQueriesGet_568762 = ref object of OpenApiRestCall_567667
proc url_EntityQueriesGet_568764(protocol: Scheme; host: string; base: string;
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

proc validate_EntityQueriesGet_568763(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an entity query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   entityQueryId: JString (required)
  ##                : entity query ID
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568765 = path.getOrDefault("resourceGroupName")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceGroupName", valid_568765
  var valid_568766 = path.getOrDefault("entityQueryId")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "entityQueryId", valid_568766
  var valid_568767 = path.getOrDefault("subscriptionId")
  valid_568767 = validateParameter(valid_568767, JString, required = true,
                                 default = nil)
  if valid_568767 != nil:
    section.add "subscriptionId", valid_568767
  var valid_568768 = path.getOrDefault("workspaceName")
  valid_568768 = validateParameter(valid_568768, JString, required = true,
                                 default = nil)
  if valid_568768 != nil:
    section.add "workspaceName", valid_568768
  var valid_568769 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "operationalInsightsResourceProvider", valid_568769
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568770 = query.getOrDefault("api-version")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568770 != nil:
    section.add "api-version", valid_568770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568771: Call_EntityQueriesGet_568762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an entity query.
  ## 
  let valid = call_568771.validator(path, query, header, formData, body)
  let scheme = call_568771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568771.url(scheme.get, call_568771.host, call_568771.base,
                         call_568771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568771, url, valid)

proc call*(call_568772: Call_EntityQueriesGet_568762; resourceGroupName: string;
          entityQueryId: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## entityQueriesGet
  ## Gets an entity query.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   entityQueryId: string (required)
  ##                : entity query ID
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568773 = newJObject()
  var query_568774 = newJObject()
  add(path_568773, "resourceGroupName", newJString(resourceGroupName))
  add(query_568774, "api-version", newJString(apiVersion))
  add(path_568773, "entityQueryId", newJString(entityQueryId))
  add(path_568773, "subscriptionId", newJString(subscriptionId))
  add(path_568773, "workspaceName", newJString(workspaceName))
  add(path_568773, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568772.call(path_568773, query_568774, nil, nil, nil)

var entityQueriesGet* = Call_EntityQueriesGet_568762(name: "entityQueriesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/entityQueries/{entityQueryId}",
    validator: validate_EntityQueriesGet_568763, base: "",
    url: url_EntityQueriesGet_568764, schemes: {Scheme.Https})
type
  Call_OfficeConsentsList_568775 = ref object of OpenApiRestCall_567667
proc url_OfficeConsentsList_568777(protocol: Scheme; host: string; base: string;
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

proc validate_OfficeConsentsList_568776(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all office365 consents.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568778 = path.getOrDefault("resourceGroupName")
  valid_568778 = validateParameter(valid_568778, JString, required = true,
                                 default = nil)
  if valid_568778 != nil:
    section.add "resourceGroupName", valid_568778
  var valid_568779 = path.getOrDefault("subscriptionId")
  valid_568779 = validateParameter(valid_568779, JString, required = true,
                                 default = nil)
  if valid_568779 != nil:
    section.add "subscriptionId", valid_568779
  var valid_568780 = path.getOrDefault("workspaceName")
  valid_568780 = validateParameter(valid_568780, JString, required = true,
                                 default = nil)
  if valid_568780 != nil:
    section.add "workspaceName", valid_568780
  var valid_568781 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568781 = validateParameter(valid_568781, JString, required = true,
                                 default = nil)
  if valid_568781 != nil:
    section.add "operationalInsightsResourceProvider", valid_568781
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568782 = query.getOrDefault("api-version")
  valid_568782 = validateParameter(valid_568782, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568782 != nil:
    section.add "api-version", valid_568782
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568783: Call_OfficeConsentsList_568775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all office365 consents.
  ## 
  let valid = call_568783.validator(path, query, header, formData, body)
  let scheme = call_568783.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568783.url(scheme.get, call_568783.host, call_568783.base,
                         call_568783.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568783, url, valid)

proc call*(call_568784: Call_OfficeConsentsList_568775; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsList
  ## Gets all office365 consents.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568785 = newJObject()
  var query_568786 = newJObject()
  add(path_568785, "resourceGroupName", newJString(resourceGroupName))
  add(query_568786, "api-version", newJString(apiVersion))
  add(path_568785, "subscriptionId", newJString(subscriptionId))
  add(path_568785, "workspaceName", newJString(workspaceName))
  add(path_568785, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568784.call(path_568785, query_568786, nil, nil, nil)

var officeConsentsList* = Call_OfficeConsentsList_568775(
    name: "officeConsentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents",
    validator: validate_OfficeConsentsList_568776, base: "",
    url: url_OfficeConsentsList_568777, schemes: {Scheme.Https})
type
  Call_OfficeConsentsGet_568787 = ref object of OpenApiRestCall_567667
proc url_OfficeConsentsGet_568789(protocol: Scheme; host: string; base: string;
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

proc validate_OfficeConsentsGet_568788(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets an office365 consent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: JString (required)
  ##            : consent ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568790 = path.getOrDefault("resourceGroupName")
  valid_568790 = validateParameter(valid_568790, JString, required = true,
                                 default = nil)
  if valid_568790 != nil:
    section.add "resourceGroupName", valid_568790
  var valid_568791 = path.getOrDefault("subscriptionId")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = nil)
  if valid_568791 != nil:
    section.add "subscriptionId", valid_568791
  var valid_568792 = path.getOrDefault("workspaceName")
  valid_568792 = validateParameter(valid_568792, JString, required = true,
                                 default = nil)
  if valid_568792 != nil:
    section.add "workspaceName", valid_568792
  var valid_568793 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568793 = validateParameter(valid_568793, JString, required = true,
                                 default = nil)
  if valid_568793 != nil:
    section.add "operationalInsightsResourceProvider", valid_568793
  var valid_568794 = path.getOrDefault("consentId")
  valid_568794 = validateParameter(valid_568794, JString, required = true,
                                 default = nil)
  if valid_568794 != nil:
    section.add "consentId", valid_568794
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568795 = query.getOrDefault("api-version")
  valid_568795 = validateParameter(valid_568795, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568795 != nil:
    section.add "api-version", valid_568795
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568796: Call_OfficeConsentsGet_568787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an office365 consent.
  ## 
  let valid = call_568796.validator(path, query, header, formData, body)
  let scheme = call_568796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568796.url(scheme.get, call_568796.host, call_568796.base,
                         call_568796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568796, url, valid)

proc call*(call_568797: Call_OfficeConsentsGet_568787; resourceGroupName: string;
          subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; consentId: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsGet
  ## Gets an office365 consent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: string (required)
  ##            : consent ID
  var path_568798 = newJObject()
  var query_568799 = newJObject()
  add(path_568798, "resourceGroupName", newJString(resourceGroupName))
  add(query_568799, "api-version", newJString(apiVersion))
  add(path_568798, "subscriptionId", newJString(subscriptionId))
  add(path_568798, "workspaceName", newJString(workspaceName))
  add(path_568798, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_568798, "consentId", newJString(consentId))
  result = call_568797.call(path_568798, query_568799, nil, nil, nil)

var officeConsentsGet* = Call_OfficeConsentsGet_568787(name: "officeConsentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents/{consentId}",
    validator: validate_OfficeConsentsGet_568788, base: "",
    url: url_OfficeConsentsGet_568789, schemes: {Scheme.Https})
type
  Call_OfficeConsentsDelete_568800 = ref object of OpenApiRestCall_567667
proc url_OfficeConsentsDelete_568802(protocol: Scheme; host: string; base: string;
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

proc validate_OfficeConsentsDelete_568801(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete the office365 consent.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: JString (required)
  ##            : consent ID
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568803 = path.getOrDefault("resourceGroupName")
  valid_568803 = validateParameter(valid_568803, JString, required = true,
                                 default = nil)
  if valid_568803 != nil:
    section.add "resourceGroupName", valid_568803
  var valid_568804 = path.getOrDefault("subscriptionId")
  valid_568804 = validateParameter(valid_568804, JString, required = true,
                                 default = nil)
  if valid_568804 != nil:
    section.add "subscriptionId", valid_568804
  var valid_568805 = path.getOrDefault("workspaceName")
  valid_568805 = validateParameter(valid_568805, JString, required = true,
                                 default = nil)
  if valid_568805 != nil:
    section.add "workspaceName", valid_568805
  var valid_568806 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568806 = validateParameter(valid_568806, JString, required = true,
                                 default = nil)
  if valid_568806 != nil:
    section.add "operationalInsightsResourceProvider", valid_568806
  var valid_568807 = path.getOrDefault("consentId")
  valid_568807 = validateParameter(valid_568807, JString, required = true,
                                 default = nil)
  if valid_568807 != nil:
    section.add "consentId", valid_568807
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568808 = query.getOrDefault("api-version")
  valid_568808 = validateParameter(valid_568808, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568808 != nil:
    section.add "api-version", valid_568808
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568809: Call_OfficeConsentsDelete_568800; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete the office365 consent.
  ## 
  let valid = call_568809.validator(path, query, header, formData, body)
  let scheme = call_568809.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568809.url(scheme.get, call_568809.host, call_568809.base,
                         call_568809.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568809, url, valid)

proc call*(call_568810: Call_OfficeConsentsDelete_568800;
          resourceGroupName: string; subscriptionId: string; workspaceName: string;
          operationalInsightsResourceProvider: string; consentId: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## officeConsentsDelete
  ## Delete the office365 consent.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  ##   consentId: string (required)
  ##            : consent ID
  var path_568811 = newJObject()
  var query_568812 = newJObject()
  add(path_568811, "resourceGroupName", newJString(resourceGroupName))
  add(query_568812, "api-version", newJString(apiVersion))
  add(path_568811, "subscriptionId", newJString(subscriptionId))
  add(path_568811, "workspaceName", newJString(workspaceName))
  add(path_568811, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  add(path_568811, "consentId", newJString(consentId))
  result = call_568810.call(path_568811, query_568812, nil, nil, nil)

var officeConsentsDelete* = Call_OfficeConsentsDelete_568800(
    name: "officeConsentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/officeConsents/{consentId}",
    validator: validate_OfficeConsentsDelete_568801, base: "",
    url: url_OfficeConsentsDelete_568802, schemes: {Scheme.Https})
type
  Call_ProductSettingsUpdate_568826 = ref object of OpenApiRestCall_567667
proc url_ProductSettingsUpdate_568828(protocol: Scheme; host: string; base: string;
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

proc validate_ProductSettingsUpdate_568827(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   settingsName: JString (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568829 = path.getOrDefault("resourceGroupName")
  valid_568829 = validateParameter(valid_568829, JString, required = true,
                                 default = nil)
  if valid_568829 != nil:
    section.add "resourceGroupName", valid_568829
  var valid_568830 = path.getOrDefault("subscriptionId")
  valid_568830 = validateParameter(valid_568830, JString, required = true,
                                 default = nil)
  if valid_568830 != nil:
    section.add "subscriptionId", valid_568830
  var valid_568831 = path.getOrDefault("settingsName")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = nil)
  if valid_568831 != nil:
    section.add "settingsName", valid_568831
  var valid_568832 = path.getOrDefault("workspaceName")
  valid_568832 = validateParameter(valid_568832, JString, required = true,
                                 default = nil)
  if valid_568832 != nil:
    section.add "workspaceName", valid_568832
  var valid_568833 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568833 = validateParameter(valid_568833, JString, required = true,
                                 default = nil)
  if valid_568833 != nil:
    section.add "operationalInsightsResourceProvider", valid_568833
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568834 = query.getOrDefault("api-version")
  valid_568834 = validateParameter(valid_568834, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568834 != nil:
    section.add "api-version", valid_568834
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

proc call*(call_568836: Call_ProductSettingsUpdate_568826; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the setting.
  ## 
  let valid = call_568836.validator(path, query, header, formData, body)
  let scheme = call_568836.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568836.url(scheme.get, call_568836.host, call_568836.base,
                         call_568836.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568836, url, valid)

proc call*(call_568837: Call_ProductSettingsUpdate_568826; settings: JsonNode;
          resourceGroupName: string; subscriptionId: string; settingsName: string;
          workspaceName: string; operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## productSettingsUpdate
  ## Updates the setting.
  ##   settings: JObject (required)
  ##           : The setting
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   settingsName: string (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568838 = newJObject()
  var query_568839 = newJObject()
  var body_568840 = newJObject()
  if settings != nil:
    body_568840 = settings
  add(path_568838, "resourceGroupName", newJString(resourceGroupName))
  add(query_568839, "api-version", newJString(apiVersion))
  add(path_568838, "subscriptionId", newJString(subscriptionId))
  add(path_568838, "settingsName", newJString(settingsName))
  add(path_568838, "workspaceName", newJString(workspaceName))
  add(path_568838, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568837.call(path_568838, query_568839, nil, nil, body_568840)

var productSettingsUpdate* = Call_ProductSettingsUpdate_568826(
    name: "productSettingsUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/settings/{settingsName}",
    validator: validate_ProductSettingsUpdate_568827, base: "",
    url: url_ProductSettingsUpdate_568828, schemes: {Scheme.Https})
type
  Call_ProductSettingsGet_568813 = ref object of OpenApiRestCall_567667
proc url_ProductSettingsGet_568815(protocol: Scheme; host: string; base: string;
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

proc validate_ProductSettingsGet_568814(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets a setting.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   settingsName: JString (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: JString (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: JString (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568816 = path.getOrDefault("resourceGroupName")
  valid_568816 = validateParameter(valid_568816, JString, required = true,
                                 default = nil)
  if valid_568816 != nil:
    section.add "resourceGroupName", valid_568816
  var valid_568817 = path.getOrDefault("subscriptionId")
  valid_568817 = validateParameter(valid_568817, JString, required = true,
                                 default = nil)
  if valid_568817 != nil:
    section.add "subscriptionId", valid_568817
  var valid_568818 = path.getOrDefault("settingsName")
  valid_568818 = validateParameter(valid_568818, JString, required = true,
                                 default = nil)
  if valid_568818 != nil:
    section.add "settingsName", valid_568818
  var valid_568819 = path.getOrDefault("workspaceName")
  valid_568819 = validateParameter(valid_568819, JString, required = true,
                                 default = nil)
  if valid_568819 != nil:
    section.add "workspaceName", valid_568819
  var valid_568820 = path.getOrDefault("operationalInsightsResourceProvider")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "operationalInsightsResourceProvider", valid_568820
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568821 = query.getOrDefault("api-version")
  valid_568821 = validateParameter(valid_568821, JString, required = true,
                                 default = newJString("2019-01-01-preview"))
  if valid_568821 != nil:
    section.add "api-version", valid_568821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568822: Call_ProductSettingsGet_568813; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a setting.
  ## 
  let valid = call_568822.validator(path, query, header, formData, body)
  let scheme = call_568822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568822.url(scheme.get, call_568822.host, call_568822.base,
                         call_568822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568822, url, valid)

proc call*(call_568823: Call_ProductSettingsGet_568813; resourceGroupName: string;
          subscriptionId: string; settingsName: string; workspaceName: string;
          operationalInsightsResourceProvider: string;
          apiVersion: string = "2019-01-01-preview"): Recallable =
  ## productSettingsGet
  ## Gets a setting.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   settingsName: string (required)
  ##               : The setting name. Supports- Fusion, UEBA
  ##   workspaceName: string (required)
  ##                : The name of the workspace.
  ##   operationalInsightsResourceProvider: string (required)
  ##                                      : The namespace of workspaces resource provider- Microsoft.OperationalInsights.
  var path_568824 = newJObject()
  var query_568825 = newJObject()
  add(path_568824, "resourceGroupName", newJString(resourceGroupName))
  add(query_568825, "api-version", newJString(apiVersion))
  add(path_568824, "subscriptionId", newJString(subscriptionId))
  add(path_568824, "settingsName", newJString(settingsName))
  add(path_568824, "workspaceName", newJString(workspaceName))
  add(path_568824, "operationalInsightsResourceProvider",
      newJString(operationalInsightsResourceProvider))
  result = call_568823.call(path_568824, query_568825, nil, nil, nil)

var productSettingsGet* = Call_ProductSettingsGet_568813(
    name: "productSettingsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{operationalInsightsResourceProvider}/workspaces/{workspaceName}/providers/Microsoft.SecurityInsights/settings/{settingsName}",
    validator: validate_ProductSettingsGet_568814, base: "",
    url: url_ProductSettingsGet_568815, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

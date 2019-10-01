
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ResourceManagementClient
## version: 2018-05-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides operations for working with resources and resource groups.
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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
  macServiceName = "resources"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DeploymentsCalculateTemplateHash_567888 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCalculateTemplateHash_567890(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DeploymentsCalculateTemplateHash_567889(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Calculate the hash of the given template.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568049 = query.getOrDefault("api-version")
  valid_568049 = validateParameter(valid_568049, JString, required = true,
                                 default = nil)
  if valid_568049 != nil:
    section.add "api-version", valid_568049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_DeploymentsCalculateTemplateHash_567888;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Calculate the hash of the given template.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_DeploymentsCalculateTemplateHash_567888;
          apiVersion: string; `template`: JsonNode): Recallable =
  ## deploymentsCalculateTemplateHash
  ## Calculate the hash of the given template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   template: JObject (required)
  ##           : The template provided to calculate hash.
  var query_568145 = newJObject()
  var body_568147 = newJObject()
  add(query_568145, "api-version", newJString(apiVersion))
  if `template` != nil:
    body_568147 = `template`
  result = call_568144.call(nil, query_568145, nil, nil, body_568147)

var deploymentsCalculateTemplateHash* = Call_DeploymentsCalculateTemplateHash_567888(
    name: "deploymentsCalculateTemplateHash", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Resources/calculateTemplateHash",
    validator: validate_DeploymentsCalculateTemplateHash_567889, base: "",
    url: url_DeploymentsCalculateTemplateHash_567890, schemes: {Scheme.Https})
type
  Call_OperationsList_568186 = ref object of OpenApiRestCall_567666
proc url_OperationsList_568188(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_568187(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568189 = query.getOrDefault("api-version")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "api-version", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_OperationsList_568186; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_OperationsList_568186; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  var query_568192 = newJObject()
  add(query_568192, "api-version", newJString(apiVersion))
  result = call_568191.call(nil, query_568192, nil, nil, nil)

var operationsList* = Call_OperationsList_568186(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_568187, base: "", url: url_OperationsList_568188,
    schemes: {Scheme.Https})
type
  Call_ProvidersList_568193 = ref object of OpenApiRestCall_567666
proc url_ProvidersList_568195(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersList_568194(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all resource providers for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed returns all deployments.
  section = newJObject()
  var valid_568212 = query.getOrDefault("$expand")
  valid_568212 = validateParameter(valid_568212, JString, required = false,
                                 default = nil)
  if valid_568212 != nil:
    section.add "$expand", valid_568212
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568213 = query.getOrDefault("api-version")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "api-version", valid_568213
  var valid_568214 = query.getOrDefault("$top")
  valid_568214 = validateParameter(valid_568214, JInt, required = false, default = nil)
  if valid_568214 != nil:
    section.add "$top", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568215: Call_ProvidersList_568193; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all resource providers for a subscription.
  ## 
  let valid = call_568215.validator(path, query, header, formData, body)
  let scheme = call_568215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568215.url(scheme.get, call_568215.host, call_568215.base,
                         call_568215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568215, url, valid)

proc call*(call_568216: Call_ProvidersList_568193; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0): Recallable =
  ## providersList
  ## Gets all resource providers for a subscription.
  ##   Expand: string
  ##         : The properties to include in the results. For example, use &$expand=metadata in the query string to retrieve resource provider metadata. To include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed returns all deployments.
  var path_568217 = newJObject()
  var query_568218 = newJObject()
  add(query_568218, "$expand", newJString(Expand))
  add(query_568218, "api-version", newJString(apiVersion))
  add(path_568217, "subscriptionId", newJString(subscriptionId))
  add(query_568218, "$top", newJInt(Top))
  result = call_568216.call(path_568217, query_568218, nil, nil, nil)

var providersList* = Call_ProvidersList_568193(name: "providersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers",
    validator: validate_ProvidersList_568194, base: "", url: url_ProvidersList_568195,
    schemes: {Scheme.Https})
type
  Call_DeploymentsListAtSubscriptionScope_568219 = ref object of OpenApiRestCall_567666
proc url_DeploymentsListAtSubscriptionScope_568221(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListAtSubscriptionScope_568220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568222 = path.getOrDefault("subscriptionId")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "subscriptionId", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  var valid_568224 = query.getOrDefault("$top")
  valid_568224 = validateParameter(valid_568224, JInt, required = false, default = nil)
  if valid_568224 != nil:
    section.add "$top", valid_568224
  var valid_568225 = query.getOrDefault("$filter")
  valid_568225 = validateParameter(valid_568225, JString, required = false,
                                 default = nil)
  if valid_568225 != nil:
    section.add "$filter", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_DeploymentsListAtSubscriptionScope_568219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get all the deployments for a subscription.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_DeploymentsListAtSubscriptionScope_568219;
          apiVersion: string; subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListAtSubscriptionScope
  ## Get all the deployments for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "subscriptionId", newJString(subscriptionId))
  add(query_568229, "$top", newJInt(Top))
  add(query_568229, "$filter", newJString(Filter))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var deploymentsListAtSubscriptionScope* = Call_DeploymentsListAtSubscriptionScope_568219(
    name: "deploymentsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListAtSubscriptionScope_568220, base: "",
    url: url_DeploymentsListAtSubscriptionScope_568221, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568240 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCreateOrUpdateAtSubscriptionScope_568242(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdateAtSubscriptionScope_568241(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568260 = path.getOrDefault("deploymentName")
  valid_568260 = validateParameter(valid_568260, JString, required = true,
                                 default = nil)
  if valid_568260 != nil:
    section.add "deploymentName", valid_568260
  var valid_568261 = path.getOrDefault("subscriptionId")
  valid_568261 = validateParameter(valid_568261, JString, required = true,
                                 default = nil)
  if valid_568261 != nil:
    section.add "subscriptionId", valid_568261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = nil)
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568264: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568264.validator(path, query, header, formData, body)
  let scheme = call_568264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568264.url(scheme.get, call_568264.host, call_568264.base,
                         call_568264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568264, url, valid)

proc call*(call_568265: Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568240;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdateAtSubscriptionScope
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568266 = newJObject()
  var query_568267 = newJObject()
  var body_568268 = newJObject()
  add(query_568267, "api-version", newJString(apiVersion))
  add(path_568266, "deploymentName", newJString(deploymentName))
  add(path_568266, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568268 = parameters
  result = call_568265.call(path_568266, query_568267, nil, nil, body_568268)

var deploymentsCreateOrUpdateAtSubscriptionScope* = Call_DeploymentsCreateOrUpdateAtSubscriptionScope_568240(
    name: "deploymentsCreateOrUpdateAtSubscriptionScope",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdateAtSubscriptionScope_568241,
    base: "", url: url_DeploymentsCreateOrUpdateAtSubscriptionScope_568242,
    schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistenceAtSubscriptionScope_568279 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCheckExistenceAtSubscriptionScope_568281(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistenceAtSubscriptionScope_568280(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to check.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568282 = path.getOrDefault("deploymentName")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "deploymentName", valid_568282
  var valid_568283 = path.getOrDefault("subscriptionId")
  valid_568283 = validateParameter(valid_568283, JString, required = true,
                                 default = nil)
  if valid_568283 != nil:
    section.add "subscriptionId", valid_568283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568284 = query.getOrDefault("api-version")
  valid_568284 = validateParameter(valid_568284, JString, required = true,
                                 default = nil)
  if valid_568284 != nil:
    section.add "api-version", valid_568284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568285: Call_DeploymentsCheckExistenceAtSubscriptionScope_568279;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568285.validator(path, query, header, formData, body)
  let scheme = call_568285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568285.url(scheme.get, call_568285.host, call_568285.base,
                         call_568285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568285, url, valid)

proc call*(call_568286: Call_DeploymentsCheckExistenceAtSubscriptionScope_568279;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCheckExistenceAtSubscriptionScope
  ## Checks whether the deployment exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to check.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568287 = newJObject()
  var query_568288 = newJObject()
  add(query_568288, "api-version", newJString(apiVersion))
  add(path_568287, "deploymentName", newJString(deploymentName))
  add(path_568287, "subscriptionId", newJString(subscriptionId))
  result = call_568286.call(path_568287, query_568288, nil, nil, nil)

var deploymentsCheckExistenceAtSubscriptionScope* = Call_DeploymentsCheckExistenceAtSubscriptionScope_568279(
    name: "deploymentsCheckExistenceAtSubscriptionScope",
    meth: HttpMethod.HttpHead, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistenceAtSubscriptionScope_568280,
    base: "", url: url_DeploymentsCheckExistenceAtSubscriptionScope_568281,
    schemes: {Scheme.Https})
type
  Call_DeploymentsGetAtSubscriptionScope_568230 = ref object of OpenApiRestCall_567666
proc url_DeploymentsGetAtSubscriptionScope_568232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGetAtSubscriptionScope_568231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568233 = path.getOrDefault("deploymentName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "deploymentName", valid_568233
  var valid_568234 = path.getOrDefault("subscriptionId")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "subscriptionId", valid_568234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568235 = query.getOrDefault("api-version")
  valid_568235 = validateParameter(valid_568235, JString, required = true,
                                 default = nil)
  if valid_568235 != nil:
    section.add "api-version", valid_568235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_DeploymentsGetAtSubscriptionScope_568230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_DeploymentsGetAtSubscriptionScope_568230;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGetAtSubscriptionScope
  ## Gets a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to get.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "deploymentName", newJString(deploymentName))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  result = call_568237.call(path_568238, query_568239, nil, nil, nil)

var deploymentsGetAtSubscriptionScope* = Call_DeploymentsGetAtSubscriptionScope_568230(
    name: "deploymentsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGetAtSubscriptionScope_568231, base: "",
    url: url_DeploymentsGetAtSubscriptionScope_568232, schemes: {Scheme.Https})
type
  Call_DeploymentsDeleteAtSubscriptionScope_568269 = ref object of OpenApiRestCall_567666
proc url_DeploymentsDeleteAtSubscriptionScope_568271(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDeleteAtSubscriptionScope_568270(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to delete.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568272 = path.getOrDefault("deploymentName")
  valid_568272 = validateParameter(valid_568272, JString, required = true,
                                 default = nil)
  if valid_568272 != nil:
    section.add "deploymentName", valid_568272
  var valid_568273 = path.getOrDefault("subscriptionId")
  valid_568273 = validateParameter(valid_568273, JString, required = true,
                                 default = nil)
  if valid_568273 != nil:
    section.add "subscriptionId", valid_568273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568274 = query.getOrDefault("api-version")
  valid_568274 = validateParameter(valid_568274, JString, required = true,
                                 default = nil)
  if valid_568274 != nil:
    section.add "api-version", valid_568274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568275: Call_DeploymentsDeleteAtSubscriptionScope_568269;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568275.validator(path, query, header, formData, body)
  let scheme = call_568275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568275.url(scheme.get, call_568275.host, call_568275.base,
                         call_568275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568275, url, valid)

proc call*(call_568276: Call_DeploymentsDeleteAtSubscriptionScope_568269;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDeleteAtSubscriptionScope
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to delete.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568277 = newJObject()
  var query_568278 = newJObject()
  add(query_568278, "api-version", newJString(apiVersion))
  add(path_568277, "deploymentName", newJString(deploymentName))
  add(path_568277, "subscriptionId", newJString(subscriptionId))
  result = call_568276.call(path_568277, query_568278, nil, nil, nil)

var deploymentsDeleteAtSubscriptionScope* = Call_DeploymentsDeleteAtSubscriptionScope_568269(
    name: "deploymentsDeleteAtSubscriptionScope", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDeleteAtSubscriptionScope_568270, base: "",
    url: url_DeploymentsDeleteAtSubscriptionScope_568271, schemes: {Scheme.Https})
type
  Call_DeploymentsCancelAtSubscriptionScope_568289 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCancelAtSubscriptionScope_568291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancelAtSubscriptionScope_568290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to cancel.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568292 = path.getOrDefault("deploymentName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "deploymentName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568294 = query.getOrDefault("api-version")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "api-version", valid_568294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568295: Call_DeploymentsCancelAtSubscriptionScope_568289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ## 
  let valid = call_568295.validator(path, query, header, formData, body)
  let scheme = call_568295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568295.url(scheme.get, call_568295.host, call_568295.base,
                         call_568295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568295, url, valid)

proc call*(call_568296: Call_DeploymentsCancelAtSubscriptionScope_568289;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancelAtSubscriptionScope
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resources partially deployed.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to cancel.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568297 = newJObject()
  var query_568298 = newJObject()
  add(query_568298, "api-version", newJString(apiVersion))
  add(path_568297, "deploymentName", newJString(deploymentName))
  add(path_568297, "subscriptionId", newJString(subscriptionId))
  result = call_568296.call(path_568297, query_568298, nil, nil, nil)

var deploymentsCancelAtSubscriptionScope* = Call_DeploymentsCancelAtSubscriptionScope_568289(
    name: "deploymentsCancelAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancelAtSubscriptionScope_568290, base: "",
    url: url_DeploymentsCancelAtSubscriptionScope_568291, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplateAtSubscriptionScope_568299 = ref object of OpenApiRestCall_567666
proc url_DeploymentsExportTemplateAtSubscriptionScope_568301(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplateAtSubscriptionScope_568300(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment from which to get the template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568302 = path.getOrDefault("deploymentName")
  valid_568302 = validateParameter(valid_568302, JString, required = true,
                                 default = nil)
  if valid_568302 != nil:
    section.add "deploymentName", valid_568302
  var valid_568303 = path.getOrDefault("subscriptionId")
  valid_568303 = validateParameter(valid_568303, JString, required = true,
                                 default = nil)
  if valid_568303 != nil:
    section.add "subscriptionId", valid_568303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568304 = query.getOrDefault("api-version")
  valid_568304 = validateParameter(valid_568304, JString, required = true,
                                 default = nil)
  if valid_568304 != nil:
    section.add "api-version", valid_568304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568305: Call_DeploymentsExportTemplateAtSubscriptionScope_568299;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568305.validator(path, query, header, formData, body)
  let scheme = call_568305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568305.url(scheme.get, call_568305.host, call_568305.base,
                         call_568305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568305, url, valid)

proc call*(call_568306: Call_DeploymentsExportTemplateAtSubscriptionScope_568299;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsExportTemplateAtSubscriptionScope
  ## Exports the template used for specified deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment from which to get the template.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568307 = newJObject()
  var query_568308 = newJObject()
  add(query_568308, "api-version", newJString(apiVersion))
  add(path_568307, "deploymentName", newJString(deploymentName))
  add(path_568307, "subscriptionId", newJString(subscriptionId))
  result = call_568306.call(path_568307, query_568308, nil, nil, nil)

var deploymentsExportTemplateAtSubscriptionScope* = Call_DeploymentsExportTemplateAtSubscriptionScope_568299(
    name: "deploymentsExportTemplateAtSubscriptionScope",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplateAtSubscriptionScope_568300,
    base: "", url: url_DeploymentsExportTemplateAtSubscriptionScope_568301,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsListAtSubscriptionScope_568309 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsListAtSubscriptionScope_568311(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsListAtSubscriptionScope_568310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment with the operation to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568312 = path.getOrDefault("deploymentName")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "deploymentName", valid_568312
  var valid_568313 = path.getOrDefault("subscriptionId")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "subscriptionId", valid_568313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568314 = query.getOrDefault("api-version")
  valid_568314 = validateParameter(valid_568314, JString, required = true,
                                 default = nil)
  if valid_568314 != nil:
    section.add "api-version", valid_568314
  var valid_568315 = query.getOrDefault("$top")
  valid_568315 = validateParameter(valid_568315, JInt, required = false, default = nil)
  if valid_568315 != nil:
    section.add "$top", valid_568315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568316: Call_DeploymentOperationsListAtSubscriptionScope_568309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568316.validator(path, query, header, formData, body)
  let scheme = call_568316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568316.url(scheme.get, call_568316.host, call_568316.base,
                         call_568316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568316, url, valid)

proc call*(call_568317: Call_DeploymentOperationsListAtSubscriptionScope_568309;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          Top: int = 0): Recallable =
  ## deploymentOperationsListAtSubscriptionScope
  ## Gets all deployments operations for a deployment.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment with the operation to get.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_568318 = newJObject()
  var query_568319 = newJObject()
  add(query_568319, "api-version", newJString(apiVersion))
  add(path_568318, "deploymentName", newJString(deploymentName))
  add(path_568318, "subscriptionId", newJString(subscriptionId))
  add(query_568319, "$top", newJInt(Top))
  result = call_568317.call(path_568318, query_568319, nil, nil, nil)

var deploymentOperationsListAtSubscriptionScope* = Call_DeploymentOperationsListAtSubscriptionScope_568309(
    name: "deploymentOperationsListAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsListAtSubscriptionScope_568310,
    base: "", url: url_DeploymentOperationsListAtSubscriptionScope_568311,
    schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGetAtSubscriptionScope_568320 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsGetAtSubscriptionScope_568322(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGetAtSubscriptionScope_568321(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568323 = path.getOrDefault("deploymentName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "deploymentName", valid_568323
  var valid_568324 = path.getOrDefault("subscriptionId")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "subscriptionId", valid_568324
  var valid_568325 = path.getOrDefault("operationId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "operationId", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_DeploymentOperationsGetAtSubscriptionScope_568320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_DeploymentOperationsGetAtSubscriptionScope_568320;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          operationId: string): Recallable =
  ## deploymentOperationsGetAtSubscriptionScope
  ## Gets a deployments operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "deploymentName", newJString(deploymentName))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "operationId", newJString(operationId))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var deploymentOperationsGetAtSubscriptionScope* = Call_DeploymentOperationsGetAtSubscriptionScope_568320(
    name: "deploymentOperationsGetAtSubscriptionScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGetAtSubscriptionScope_568321,
    base: "", url: url_DeploymentOperationsGetAtSubscriptionScope_568322,
    schemes: {Scheme.Https})
type
  Call_DeploymentsValidateAtSubscriptionScope_568331 = ref object of OpenApiRestCall_567666
proc url_DeploymentsValidateAtSubscriptionScope_568333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidateAtSubscriptionScope_568332(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `deploymentName` field"
  var valid_568334 = path.getOrDefault("deploymentName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "deploymentName", valid_568334
  var valid_568335 = path.getOrDefault("subscriptionId")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "subscriptionId", valid_568335
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568336 = query.getOrDefault("api-version")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "api-version", valid_568336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568338: Call_DeploymentsValidateAtSubscriptionScope_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568338.validator(path, query, header, formData, body)
  let scheme = call_568338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568338.url(scheme.get, call_568338.host, call_568338.base,
                         call_568338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568338, url, valid)

proc call*(call_568339: Call_DeploymentsValidateAtSubscriptionScope_568331;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidateAtSubscriptionScope
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_568340 = newJObject()
  var query_568341 = newJObject()
  var body_568342 = newJObject()
  add(query_568341, "api-version", newJString(apiVersion))
  add(path_568340, "deploymentName", newJString(deploymentName))
  add(path_568340, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568342 = parameters
  result = call_568339.call(path_568340, query_568341, nil, nil, body_568342)

var deploymentsValidateAtSubscriptionScope* = Call_DeploymentsValidateAtSubscriptionScope_568331(
    name: "deploymentsValidateAtSubscriptionScope", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidateAtSubscriptionScope_568332, base: "",
    url: url_DeploymentsValidateAtSubscriptionScope_568333,
    schemes: {Scheme.Https})
type
  Call_ProvidersGet_568343 = ref object of OpenApiRestCall_567666
proc url_ProvidersGet_568345(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersGet_568344(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the specified resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568346 = path.getOrDefault("subscriptionId")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "subscriptionId", valid_568346
  var valid_568347 = path.getOrDefault("resourceProviderNamespace")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "resourceProviderNamespace", valid_568347
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  var valid_568348 = query.getOrDefault("$expand")
  valid_568348 = validateParameter(valid_568348, JString, required = false,
                                 default = nil)
  if valid_568348 != nil:
    section.add "$expand", valid_568348
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568349 = query.getOrDefault("api-version")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "api-version", valid_568349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568350: Call_ProvidersGet_568343; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the specified resource provider.
  ## 
  let valid = call_568350.validator(path, query, header, formData, body)
  let scheme = call_568350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568350.url(scheme.get, call_568350.host, call_568350.base,
                         call_568350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568350, url, valid)

proc call*(call_568351: Call_ProvidersGet_568343; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string;
          Expand: string = ""): Recallable =
  ## providersGet
  ## Gets the specified resource provider.
  ##   Expand: string
  ##         : The $expand query parameter. For example, to include property aliases in response, use $expand=resourceTypes/aliases.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  var path_568352 = newJObject()
  var query_568353 = newJObject()
  add(query_568353, "$expand", newJString(Expand))
  add(query_568353, "api-version", newJString(apiVersion))
  add(path_568352, "subscriptionId", newJString(subscriptionId))
  add(path_568352, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568351.call(path_568352, query_568353, nil, nil, nil)

var providersGet* = Call_ProvidersGet_568343(name: "providersGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}",
    validator: validate_ProvidersGet_568344, base: "", url: url_ProvidersGet_568345,
    schemes: {Scheme.Https})
type
  Call_ProvidersRegister_568354 = ref object of OpenApiRestCall_567666
proc url_ProvidersRegister_568356(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/register")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersRegister_568355(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Registers a subscription with a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to register.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568357 = path.getOrDefault("subscriptionId")
  valid_568357 = validateParameter(valid_568357, JString, required = true,
                                 default = nil)
  if valid_568357 != nil:
    section.add "subscriptionId", valid_568357
  var valid_568358 = path.getOrDefault("resourceProviderNamespace")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "resourceProviderNamespace", valid_568358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_ProvidersRegister_568354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Registers a subscription with a resource provider.
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_ProvidersRegister_568354; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersRegister
  ## Registers a subscription with a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to register.
  var path_568362 = newJObject()
  var query_568363 = newJObject()
  add(query_568363, "api-version", newJString(apiVersion))
  add(path_568362, "subscriptionId", newJString(subscriptionId))
  add(path_568362, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568361.call(path_568362, query_568363, nil, nil, nil)

var providersRegister* = Call_ProvidersRegister_568354(name: "providersRegister",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/register",
    validator: validate_ProvidersRegister_568355, base: "",
    url: url_ProvidersRegister_568356, schemes: {Scheme.Https})
type
  Call_ProvidersUnregister_568364 = ref object of OpenApiRestCall_567666
proc url_ProvidersUnregister_568366(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/unregister")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProvidersUnregister_568365(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Unregisters a subscription from a resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider to unregister.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568367 = path.getOrDefault("subscriptionId")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "subscriptionId", valid_568367
  var valid_568368 = path.getOrDefault("resourceProviderNamespace")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "resourceProviderNamespace", valid_568368
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568369 = query.getOrDefault("api-version")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "api-version", valid_568369
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568370: Call_ProvidersUnregister_568364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Unregisters a subscription from a resource provider.
  ## 
  let valid = call_568370.validator(path, query, header, formData, body)
  let scheme = call_568370.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568370.url(scheme.get, call_568370.host, call_568370.base,
                         call_568370.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568370, url, valid)

proc call*(call_568371: Call_ProvidersUnregister_568364; apiVersion: string;
          subscriptionId: string; resourceProviderNamespace: string): Recallable =
  ## providersUnregister
  ## Unregisters a subscription from a resource provider.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider to unregister.
  var path_568372 = newJObject()
  var query_568373 = newJObject()
  add(query_568373, "api-version", newJString(apiVersion))
  add(path_568372, "subscriptionId", newJString(subscriptionId))
  add(path_568372, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  result = call_568371.call(path_568372, query_568373, nil, nil, nil)

var providersUnregister* = Call_ProvidersUnregister_568364(
    name: "providersUnregister", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/{resourceProviderNamespace}/unregister",
    validator: validate_ProvidersUnregister_568365, base: "",
    url: url_ProvidersUnregister_568366, schemes: {Scheme.Https})
type
  Call_ResourcesListByResourceGroup_568374 = ref object of OpenApiRestCall_567666
proc url_ResourcesListByResourceGroup_568376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesListByResourceGroup_568375(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The resource group with the resources to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568377 = path.getOrDefault("resourceGroupName")
  valid_568377 = validateParameter(valid_568377, JString, required = true,
                                 default = nil)
  if valid_568377 != nil:
    section.add "resourceGroupName", valid_568377
  var valid_568378 = path.getOrDefault("subscriptionId")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = nil)
  if valid_568378 != nil:
    section.add "subscriptionId", valid_568378
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resources.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  section = newJObject()
  var valid_568379 = query.getOrDefault("$expand")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "$expand", valid_568379
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568380 = query.getOrDefault("api-version")
  valid_568380 = validateParameter(valid_568380, JString, required = true,
                                 default = nil)
  if valid_568380 != nil:
    section.add "api-version", valid_568380
  var valid_568381 = query.getOrDefault("$top")
  valid_568381 = validateParameter(valid_568381, JInt, required = false, default = nil)
  if valid_568381 != nil:
    section.add "$top", valid_568381
  var valid_568382 = query.getOrDefault("$filter")
  valid_568382 = validateParameter(valid_568382, JString, required = false,
                                 default = nil)
  if valid_568382 != nil:
    section.add "$filter", valid_568382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568383: Call_ResourcesListByResourceGroup_568374; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources for a resource group.
  ## 
  let valid = call_568383.validator(path, query, header, formData, body)
  let scheme = call_568383.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568383.url(scheme.get, call_568383.host, call_568383.base,
                         call_568383.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568383, url, valid)

proc call*(call_568384: Call_ResourcesListByResourceGroup_568374;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesListByResourceGroup
  ## Get all the resources for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The resource group with the resources to get.
  ##   Expand: string
  ##         : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resources.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  var path_568385 = newJObject()
  var query_568386 = newJObject()
  add(path_568385, "resourceGroupName", newJString(resourceGroupName))
  add(query_568386, "$expand", newJString(Expand))
  add(query_568386, "api-version", newJString(apiVersion))
  add(path_568385, "subscriptionId", newJString(subscriptionId))
  add(query_568386, "$top", newJInt(Top))
  add(query_568386, "$filter", newJString(Filter))
  result = call_568384.call(path_568385, query_568386, nil, nil, nil)

var resourcesListByResourceGroup* = Call_ResourcesListByResourceGroup_568374(
    name: "resourcesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources",
    validator: validate_ResourcesListByResourceGroup_568375, base: "",
    url: url_ResourcesListByResourceGroup_568376, schemes: {Scheme.Https})
type
  Call_ResourcesMoveResources_568387 = ref object of OpenApiRestCall_567666
proc url_ResourcesMoveResources_568389(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesMoveResources_568388(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_568390 = path.getOrDefault("sourceResourceGroupName")
  valid_568390 = validateParameter(valid_568390, JString, required = true,
                                 default = nil)
  if valid_568390 != nil:
    section.add "sourceResourceGroupName", valid_568390
  var valid_568391 = path.getOrDefault("subscriptionId")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = nil)
  if valid_568391 != nil:
    section.add "subscriptionId", valid_568391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568392 = query.getOrDefault("api-version")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "api-version", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568394: Call_ResourcesMoveResources_568387; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ## 
  let valid = call_568394.validator(path, query, header, formData, body)
  let scheme = call_568394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568394.url(scheme.get, call_568394.host, call_568394.base,
                         call_568394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568394, url, valid)

proc call*(call_568395: Call_ResourcesMoveResources_568387; apiVersion: string;
          sourceResourceGroupName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourcesMoveResources
  ## The resources to move must be in the same source resource group. The target resource group may be in a different subscription. When moving resources, both the source group and the target group are locked for the duration of the operation. Write and delete operations are blocked on the groups until the move completes. 
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_568396 = newJObject()
  var query_568397 = newJObject()
  var body_568398 = newJObject()
  add(query_568397, "api-version", newJString(apiVersion))
  add(path_568396, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568396, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568398 = parameters
  result = call_568395.call(path_568396, query_568397, nil, nil, body_568398)

var resourcesMoveResources* = Call_ResourcesMoveResources_568387(
    name: "resourcesMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/moveResources",
    validator: validate_ResourcesMoveResources_568388, base: "",
    url: url_ResourcesMoveResources_568389, schemes: {Scheme.Https})
type
  Call_ResourcesValidateMoveResources_568399 = ref object of OpenApiRestCall_567666
proc url_ResourcesValidateMoveResources_568401(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "sourceResourceGroupName" in path,
        "`sourceResourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "sourceResourceGroupName"),
               (kind: ConstantSegment, value: "/validateMoveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesValidateMoveResources_568400(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sourceResourceGroupName: JString (required)
  ##                          : The name of the resource group containing the resources to validate for move.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sourceResourceGroupName` field"
  var valid_568402 = path.getOrDefault("sourceResourceGroupName")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = nil)
  if valid_568402 != nil:
    section.add "sourceResourceGroupName", valid_568402
  var valid_568403 = path.getOrDefault("subscriptionId")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "subscriptionId", valid_568403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568404 = query.getOrDefault("api-version")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "api-version", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568406: Call_ResourcesValidateMoveResources_568399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ## 
  let valid = call_568406.validator(path, query, header, formData, body)
  let scheme = call_568406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568406.url(scheme.get, call_568406.host, call_568406.base,
                         call_568406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568406, url, valid)

proc call*(call_568407: Call_ResourcesValidateMoveResources_568399;
          apiVersion: string; sourceResourceGroupName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## resourcesValidateMoveResources
  ## This operation checks whether the specified resources can be moved to the target. The resources to move must be in the same source resource group. The target resource group may be in a different subscription. If validation succeeds, it returns HTTP response code 204 (no content). If validation fails, it returns HTTP response code 409 (Conflict) with an error message. Retrieve the URL in the Location header value to check the result of the long-running operation.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   sourceResourceGroupName: string (required)
  ##                          : The name of the resource group containing the resources to validate for move.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for moving resources.
  var path_568408 = newJObject()
  var query_568409 = newJObject()
  var body_568410 = newJObject()
  add(query_568409, "api-version", newJString(apiVersion))
  add(path_568408, "sourceResourceGroupName", newJString(sourceResourceGroupName))
  add(path_568408, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568410 = parameters
  result = call_568407.call(path_568408, query_568409, nil, nil, body_568410)

var resourcesValidateMoveResources* = Call_ResourcesValidateMoveResources_568399(
    name: "resourcesValidateMoveResources", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{sourceResourceGroupName}/validateMoveResources",
    validator: validate_ResourcesValidateMoveResources_568400, base: "",
    url: url_ResourcesValidateMoveResources_568401, schemes: {Scheme.Https})
type
  Call_ResourceGroupsList_568411 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsList_568413(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsList_568412(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets all the resource groups for a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568414 = path.getOrDefault("subscriptionId")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = nil)
  if valid_568414 != nil:
    section.add "subscriptionId", valid_568414
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568415 = query.getOrDefault("api-version")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "api-version", valid_568415
  var valid_568416 = query.getOrDefault("$top")
  valid_568416 = validateParameter(valid_568416, JInt, required = false, default = nil)
  if valid_568416 != nil:
    section.add "$top", valid_568416
  var valid_568417 = query.getOrDefault("$filter")
  valid_568417 = validateParameter(valid_568417, JString, required = false,
                                 default = nil)
  if valid_568417 != nil:
    section.add "$filter", valid_568417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568418: Call_ResourceGroupsList_568411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all the resource groups for a subscription.
  ## 
  let valid = call_568418.validator(path, query, header, formData, body)
  let scheme = call_568418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568418.url(scheme.get, call_568418.host, call_568418.base,
                         call_568418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568418, url, valid)

proc call*(call_568419: Call_ResourceGroupsList_568411; apiVersion: string;
          subscriptionId: string; Top: int = 0; Filter: string = ""): Recallable =
  ## resourceGroupsList
  ## Gets all the resource groups for a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'
  var path_568420 = newJObject()
  var query_568421 = newJObject()
  add(query_568421, "api-version", newJString(apiVersion))
  add(path_568420, "subscriptionId", newJString(subscriptionId))
  add(query_568421, "$top", newJInt(Top))
  add(query_568421, "$filter", newJString(Filter))
  result = call_568419.call(path_568420, query_568421, nil, nil, nil)

var resourceGroupsList* = Call_ResourceGroupsList_568411(
    name: "resourceGroupsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resourcegroups",
    validator: validate_ResourceGroupsList_568412, base: "",
    url: url_ResourceGroupsList_568413, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCreateOrUpdate_568432 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsCreateOrUpdate_568434(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCreateOrUpdate_568433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to create or update. Can include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568435 = path.getOrDefault("resourceGroupName")
  valid_568435 = validateParameter(valid_568435, JString, required = true,
                                 default = nil)
  if valid_568435 != nil:
    section.add "resourceGroupName", valid_568435
  var valid_568436 = path.getOrDefault("subscriptionId")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = nil)
  if valid_568436 != nil:
    section.add "subscriptionId", valid_568436
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568437 = query.getOrDefault("api-version")
  valid_568437 = validateParameter(valid_568437, JString, required = true,
                                 default = nil)
  if valid_568437 != nil:
    section.add "api-version", valid_568437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568439: Call_ResourceGroupsCreateOrUpdate_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a resource group.
  ## 
  let valid = call_568439.validator(path, query, header, formData, body)
  let scheme = call_568439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568439.url(scheme.get, call_568439.host, call_568439.base,
                         call_568439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568439, url, valid)

proc call*(call_568440: Call_ResourceGroupsCreateOrUpdate_568432;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsCreateOrUpdate
  ## Creates or updates a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to create or update. Can include alphanumeric, underscore, parentheses, hyphen, period (except at end), and Unicode characters that match the allowed characters.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the create or update a resource group.
  var path_568441 = newJObject()
  var query_568442 = newJObject()
  var body_568443 = newJObject()
  add(path_568441, "resourceGroupName", newJString(resourceGroupName))
  add(query_568442, "api-version", newJString(apiVersion))
  add(path_568441, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568443 = parameters
  result = call_568440.call(path_568441, query_568442, nil, nil, body_568443)

var resourceGroupsCreateOrUpdate* = Call_ResourceGroupsCreateOrUpdate_568432(
    name: "resourceGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCreateOrUpdate_568433, base: "",
    url: url_ResourceGroupsCreateOrUpdate_568434, schemes: {Scheme.Https})
type
  Call_ResourceGroupsCheckExistence_568454 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsCheckExistence_568456(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsCheckExistence_568455(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource group exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568457 = path.getOrDefault("resourceGroupName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "resourceGroupName", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568459 = query.getOrDefault("api-version")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = nil)
  if valid_568459 != nil:
    section.add "api-version", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_ResourceGroupsCheckExistence_568454; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource group exists.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_ResourceGroupsCheckExistence_568454;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsCheckExistence
  ## Checks whether a resource group exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(path_568462, "resourceGroupName", newJString(resourceGroupName))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "subscriptionId", newJString(subscriptionId))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var resourceGroupsCheckExistence* = Call_ResourceGroupsCheckExistence_568454(
    name: "resourceGroupsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsCheckExistence_568455, base: "",
    url: url_ResourceGroupsCheckExistence_568456, schemes: {Scheme.Https})
type
  Call_ResourceGroupsGet_568422 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsGet_568424(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsGet_568423(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Gets a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("subscriptionId")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "subscriptionId", valid_568426
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568427 = query.getOrDefault("api-version")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "api-version", valid_568427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568428: Call_ResourceGroupsGet_568422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource group.
  ## 
  let valid = call_568428.validator(path, query, header, formData, body)
  let scheme = call_568428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568428.url(scheme.get, call_568428.host, call_568428.base,
                         call_568428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568428, url, valid)

proc call*(call_568429: Call_ResourceGroupsGet_568422; resourceGroupName: string;
          apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsGet
  ## Gets a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568430 = newJObject()
  var query_568431 = newJObject()
  add(path_568430, "resourceGroupName", newJString(resourceGroupName))
  add(query_568431, "api-version", newJString(apiVersion))
  add(path_568430, "subscriptionId", newJString(subscriptionId))
  result = call_568429.call(path_568430, query_568431, nil, nil, nil)

var resourceGroupsGet* = Call_ResourceGroupsGet_568422(name: "resourceGroupsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsGet_568423, base: "",
    url: url_ResourceGroupsGet_568424, schemes: {Scheme.Https})
type
  Call_ResourceGroupsUpdate_568464 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsUpdate_568466(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsUpdate_568465(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568467 = path.getOrDefault("resourceGroupName")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "resourceGroupName", valid_568467
  var valid_568468 = path.getOrDefault("subscriptionId")
  valid_568468 = validateParameter(valid_568468, JString, required = true,
                                 default = nil)
  if valid_568468 != nil:
    section.add "subscriptionId", valid_568468
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568469 = query.getOrDefault("api-version")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "api-version", valid_568469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_ResourceGroupsUpdate_568464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_ResourceGroupsUpdate_568464;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsUpdate
  ## Resource groups can be updated through a simple PATCH operation to a group address. The format of the request is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to update. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update a resource group.
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  var body_568475 = newJObject()
  add(path_568473, "resourceGroupName", newJString(resourceGroupName))
  add(query_568474, "api-version", newJString(apiVersion))
  add(path_568473, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568475 = parameters
  result = call_568472.call(path_568473, query_568474, nil, nil, body_568475)

var resourceGroupsUpdate* = Call_ResourceGroupsUpdate_568464(
    name: "resourceGroupsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsUpdate_568465, base: "",
    url: url_ResourceGroupsUpdate_568466, schemes: {Scheme.Https})
type
  Call_ResourceGroupsDelete_568444 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsDelete_568446(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsDelete_568445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568447 = path.getOrDefault("resourceGroupName")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = nil)
  if valid_568447 != nil:
    section.add "resourceGroupName", valid_568447
  var valid_568448 = path.getOrDefault("subscriptionId")
  valid_568448 = validateParameter(valid_568448, JString, required = true,
                                 default = nil)
  if valid_568448 != nil:
    section.add "subscriptionId", valid_568448
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568449 = query.getOrDefault("api-version")
  valid_568449 = validateParameter(valid_568449, JString, required = true,
                                 default = nil)
  if valid_568449 != nil:
    section.add "api-version", valid_568449
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568450: Call_ResourceGroupsDelete_568444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ## 
  let valid = call_568450.validator(path, query, header, formData, body)
  let scheme = call_568450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568450.url(scheme.get, call_568450.host, call_568450.base,
                         call_568450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568450, url, valid)

proc call*(call_568451: Call_ResourceGroupsDelete_568444;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## resourceGroupsDelete
  ## When you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes all of its template deployments and currently stored operations.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568452 = newJObject()
  var query_568453 = newJObject()
  add(path_568452, "resourceGroupName", newJString(resourceGroupName))
  add(query_568453, "api-version", newJString(apiVersion))
  add(path_568452, "subscriptionId", newJString(subscriptionId))
  result = call_568451.call(path_568452, query_568453, nil, nil, nil)

var resourceGroupsDelete* = Call_ResourceGroupsDelete_568444(
    name: "resourceGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}",
    validator: validate_ResourceGroupsDelete_568445, base: "",
    url: url_ResourceGroupsDelete_568446, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsList_568476 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsList_568478(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsList_568477(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all deployments operations for a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment with the operation to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568479 = path.getOrDefault("resourceGroupName")
  valid_568479 = validateParameter(valid_568479, JString, required = true,
                                 default = nil)
  if valid_568479 != nil:
    section.add "resourceGroupName", valid_568479
  var valid_568480 = path.getOrDefault("deploymentName")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = nil)
  if valid_568480 != nil:
    section.add "deploymentName", valid_568480
  var valid_568481 = path.getOrDefault("subscriptionId")
  valid_568481 = validateParameter(valid_568481, JString, required = true,
                                 default = nil)
  if valid_568481 != nil:
    section.add "subscriptionId", valid_568481
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568482 = query.getOrDefault("api-version")
  valid_568482 = validateParameter(valid_568482, JString, required = true,
                                 default = nil)
  if valid_568482 != nil:
    section.add "api-version", valid_568482
  var valid_568483 = query.getOrDefault("$top")
  valid_568483 = validateParameter(valid_568483, JInt, required = false, default = nil)
  if valid_568483 != nil:
    section.add "$top", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_DeploymentOperationsList_568476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all deployments operations for a deployment.
  ## 
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_DeploymentOperationsList_568476;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; Top: int = 0): Recallable =
  ## deploymentOperationsList
  ## Gets all deployments operations for a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment with the operation to get.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return.
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  add(path_568486, "resourceGroupName", newJString(resourceGroupName))
  add(query_568487, "api-version", newJString(apiVersion))
  add(path_568486, "deploymentName", newJString(deploymentName))
  add(path_568486, "subscriptionId", newJString(subscriptionId))
  add(query_568487, "$top", newJInt(Top))
  result = call_568485.call(path_568486, query_568487, nil, nil, nil)

var deploymentOperationsList* = Call_DeploymentOperationsList_568476(
    name: "deploymentOperationsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations",
    validator: validate_DeploymentOperationsList_568477, base: "",
    url: url_DeploymentOperationsList_568478, schemes: {Scheme.Https})
type
  Call_DeploymentOperationsGet_568488 = ref object of OpenApiRestCall_567666
proc url_DeploymentOperationsGet_568490(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  assert "operationId" in path, "`operationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/operations/"),
               (kind: VariableSegment, value: "operationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentOperationsGet_568489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a deployments operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   operationId: JString (required)
  ##              : The ID of the operation to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568491 = path.getOrDefault("resourceGroupName")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "resourceGroupName", valid_568491
  var valid_568492 = path.getOrDefault("deploymentName")
  valid_568492 = validateParameter(valid_568492, JString, required = true,
                                 default = nil)
  if valid_568492 != nil:
    section.add "deploymentName", valid_568492
  var valid_568493 = path.getOrDefault("subscriptionId")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = nil)
  if valid_568493 != nil:
    section.add "subscriptionId", valid_568493
  var valid_568494 = path.getOrDefault("operationId")
  valid_568494 = validateParameter(valid_568494, JString, required = true,
                                 default = nil)
  if valid_568494 != nil:
    section.add "operationId", valid_568494
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568495 = query.getOrDefault("api-version")
  valid_568495 = validateParameter(valid_568495, JString, required = true,
                                 default = nil)
  if valid_568495 != nil:
    section.add "api-version", valid_568495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568496: Call_DeploymentOperationsGet_568488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployments operation.
  ## 
  let valid = call_568496.validator(path, query, header, formData, body)
  let scheme = call_568496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568496.url(scheme.get, call_568496.host, call_568496.base,
                         call_568496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568496, url, valid)

proc call*(call_568497: Call_DeploymentOperationsGet_568488;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; operationId: string): Recallable =
  ## deploymentOperationsGet
  ## Gets a deployments operation.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   operationId: string (required)
  ##              : The ID of the operation to get.
  var path_568498 = newJObject()
  var query_568499 = newJObject()
  add(path_568498, "resourceGroupName", newJString(resourceGroupName))
  add(query_568499, "api-version", newJString(apiVersion))
  add(path_568498, "deploymentName", newJString(deploymentName))
  add(path_568498, "subscriptionId", newJString(subscriptionId))
  add(path_568498, "operationId", newJString(operationId))
  result = call_568497.call(path_568498, query_568499, nil, nil, nil)

var deploymentOperationsGet* = Call_DeploymentOperationsGet_568488(
    name: "deploymentOperationsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/deployments/{deploymentName}/operations/{operationId}",
    validator: validate_DeploymentOperationsGet_568489, base: "",
    url: url_DeploymentOperationsGet_568490, schemes: {Scheme.Https})
type
  Call_ResourceGroupsExportTemplate_568500 = ref object of OpenApiRestCall_567666
proc url_ResourceGroupsExportTemplate_568502(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceGroupsExportTemplate_568501(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Captures the specified resource group as a template.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to export as a template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568503 = path.getOrDefault("resourceGroupName")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "resourceGroupName", valid_568503
  var valid_568504 = path.getOrDefault("subscriptionId")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "subscriptionId", valid_568504
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568505 = query.getOrDefault("api-version")
  valid_568505 = validateParameter(valid_568505, JString, required = true,
                                 default = nil)
  if valid_568505 != nil:
    section.add "api-version", valid_568505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568507: Call_ResourceGroupsExportTemplate_568500; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Captures the specified resource group as a template.
  ## 
  let valid = call_568507.validator(path, query, header, formData, body)
  let scheme = call_568507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568507.url(scheme.get, call_568507.host, call_568507.base,
                         call_568507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568507, url, valid)

proc call*(call_568508: Call_ResourceGroupsExportTemplate_568500;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## resourceGroupsExportTemplate
  ## Captures the specified resource group as a template.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to export as a template.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters for exporting the template.
  var path_568509 = newJObject()
  var query_568510 = newJObject()
  var body_568511 = newJObject()
  add(path_568509, "resourceGroupName", newJString(resourceGroupName))
  add(query_568510, "api-version", newJString(apiVersion))
  add(path_568509, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568511 = parameters
  result = call_568508.call(path_568509, query_568510, nil, nil, body_568511)

var resourceGroupsExportTemplate* = Call_ResourceGroupsExportTemplate_568500(
    name: "resourceGroupsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/exportTemplate",
    validator: validate_ResourceGroupsExportTemplate_568501, base: "",
    url: url_ResourceGroupsExportTemplate_568502, schemes: {Scheme.Https})
type
  Call_DeploymentsListByResourceGroup_568512 = ref object of OpenApiRestCall_567666
proc url_DeploymentsListByResourceGroup_568514(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsListByResourceGroup_568513(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the deployments for a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568515 = path.getOrDefault("resourceGroupName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "resourceGroupName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to get. If null is passed, returns all deployments.
  ##   $filter: JString
  ##          : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568517 = query.getOrDefault("api-version")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "api-version", valid_568517
  var valid_568518 = query.getOrDefault("$top")
  valid_568518 = validateParameter(valid_568518, JInt, required = false, default = nil)
  if valid_568518 != nil:
    section.add "$top", valid_568518
  var valid_568519 = query.getOrDefault("$filter")
  valid_568519 = validateParameter(valid_568519, JString, required = false,
                                 default = nil)
  if valid_568519 != nil:
    section.add "$filter", valid_568519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_DeploymentsListByResourceGroup_568512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the deployments for a resource group.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_DeploymentsListByResourceGroup_568512;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Filter: string = ""): Recallable =
  ## deploymentsListByResourceGroup
  ## Get all the deployments for a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployments to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to get. If null is passed, returns all deployments.
  ##   Filter: string
  ##         : The filter to apply on the operation. For example, you can use $filter=provisioningState eq '{state}'.
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  add(query_568523, "$top", newJInt(Top))
  add(query_568523, "$filter", newJString(Filter))
  result = call_568521.call(path_568522, query_568523, nil, nil, nil)

var deploymentsListByResourceGroup* = Call_DeploymentsListByResourceGroup_568512(
    name: "deploymentsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/",
    validator: validate_DeploymentsListByResourceGroup_568513, base: "",
    url: url_DeploymentsListByResourceGroup_568514, schemes: {Scheme.Https})
type
  Call_DeploymentsCreateOrUpdate_568535 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCreateOrUpdate_568537(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCreateOrUpdate_568536(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568538 = path.getOrDefault("resourceGroupName")
  valid_568538 = validateParameter(valid_568538, JString, required = true,
                                 default = nil)
  if valid_568538 != nil:
    section.add "resourceGroupName", valid_568538
  var valid_568539 = path.getOrDefault("deploymentName")
  valid_568539 = validateParameter(valid_568539, JString, required = true,
                                 default = nil)
  if valid_568539 != nil:
    section.add "deploymentName", valid_568539
  var valid_568540 = path.getOrDefault("subscriptionId")
  valid_568540 = validateParameter(valid_568540, JString, required = true,
                                 default = nil)
  if valid_568540 != nil:
    section.add "subscriptionId", valid_568540
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568541 = query.getOrDefault("api-version")
  valid_568541 = validateParameter(valid_568541, JString, required = true,
                                 default = nil)
  if valid_568541 != nil:
    section.add "api-version", valid_568541
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568543: Call_DeploymentsCreateOrUpdate_568535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ## 
  let valid = call_568543.validator(path, query, header, formData, body)
  let scheme = call_568543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568543.url(scheme.get, call_568543.host, call_568543.base,
                         call_568543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568543, url, valid)

proc call*(call_568544: Call_DeploymentsCreateOrUpdate_568535;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## deploymentsCreateOrUpdate
  ## You can provide the template and parameters directly in the request or link to JSON files.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to deploy the resources to. The name is case insensitive. The resource group must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Additional parameters supplied to the operation.
  var path_568545 = newJObject()
  var query_568546 = newJObject()
  var body_568547 = newJObject()
  add(path_568545, "resourceGroupName", newJString(resourceGroupName))
  add(query_568546, "api-version", newJString(apiVersion))
  add(path_568545, "deploymentName", newJString(deploymentName))
  add(path_568545, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568547 = parameters
  result = call_568544.call(path_568545, query_568546, nil, nil, body_568547)

var deploymentsCreateOrUpdate* = Call_DeploymentsCreateOrUpdate_568535(
    name: "deploymentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCreateOrUpdate_568536, base: "",
    url: url_DeploymentsCreateOrUpdate_568537, schemes: {Scheme.Https})
type
  Call_DeploymentsCheckExistence_568559 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCheckExistence_568561(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCheckExistence_568560(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the deployment exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to check.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568562 = path.getOrDefault("resourceGroupName")
  valid_568562 = validateParameter(valid_568562, JString, required = true,
                                 default = nil)
  if valid_568562 != nil:
    section.add "resourceGroupName", valid_568562
  var valid_568563 = path.getOrDefault("deploymentName")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "deploymentName", valid_568563
  var valid_568564 = path.getOrDefault("subscriptionId")
  valid_568564 = validateParameter(valid_568564, JString, required = true,
                                 default = nil)
  if valid_568564 != nil:
    section.add "subscriptionId", valid_568564
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568565 = query.getOrDefault("api-version")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = nil)
  if valid_568565 != nil:
    section.add "api-version", valid_568565
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568566: Call_DeploymentsCheckExistence_568559; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the deployment exists.
  ## 
  let valid = call_568566.validator(path, query, header, formData, body)
  let scheme = call_568566.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568566.url(scheme.get, call_568566.host, call_568566.base,
                         call_568566.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568566, url, valid)

proc call*(call_568567: Call_DeploymentsCheckExistence_568559;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsCheckExistence
  ## Checks whether the deployment exists.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to check.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568568 = newJObject()
  var query_568569 = newJObject()
  add(path_568568, "resourceGroupName", newJString(resourceGroupName))
  add(query_568569, "api-version", newJString(apiVersion))
  add(path_568568, "deploymentName", newJString(deploymentName))
  add(path_568568, "subscriptionId", newJString(subscriptionId))
  result = call_568567.call(path_568568, query_568569, nil, nil, nil)

var deploymentsCheckExistence* = Call_DeploymentsCheckExistence_568559(
    name: "deploymentsCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsCheckExistence_568560, base: "",
    url: url_DeploymentsCheckExistence_568561, schemes: {Scheme.Https})
type
  Call_DeploymentsGet_568524 = ref object of OpenApiRestCall_567666
proc url_DeploymentsGet_568526(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsGet_568525(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets a deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to get.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568527 = path.getOrDefault("resourceGroupName")
  valid_568527 = validateParameter(valid_568527, JString, required = true,
                                 default = nil)
  if valid_568527 != nil:
    section.add "resourceGroupName", valid_568527
  var valid_568528 = path.getOrDefault("deploymentName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "deploymentName", valid_568528
  var valid_568529 = path.getOrDefault("subscriptionId")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "subscriptionId", valid_568529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568530 = query.getOrDefault("api-version")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "api-version", valid_568530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568531: Call_DeploymentsGet_568524; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a deployment.
  ## 
  let valid = call_568531.validator(path, query, header, formData, body)
  let scheme = call_568531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568531.url(scheme.get, call_568531.host, call_568531.base,
                         call_568531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568531, url, valid)

proc call*(call_568532: Call_DeploymentsGet_568524; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsGet
  ## Gets a deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to get.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568533 = newJObject()
  var query_568534 = newJObject()
  add(path_568533, "resourceGroupName", newJString(resourceGroupName))
  add(query_568534, "api-version", newJString(apiVersion))
  add(path_568533, "deploymentName", newJString(deploymentName))
  add(path_568533, "subscriptionId", newJString(subscriptionId))
  result = call_568532.call(path_568533, query_568534, nil, nil, nil)

var deploymentsGet* = Call_DeploymentsGet_568524(name: "deploymentsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsGet_568525, base: "", url: url_DeploymentsGet_568526,
    schemes: {Scheme.Https})
type
  Call_DeploymentsDelete_568548 = ref object of OpenApiRestCall_567666
proc url_DeploymentsDelete_568550(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsDelete_568549(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to delete.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568551 = path.getOrDefault("resourceGroupName")
  valid_568551 = validateParameter(valid_568551, JString, required = true,
                                 default = nil)
  if valid_568551 != nil:
    section.add "resourceGroupName", valid_568551
  var valid_568552 = path.getOrDefault("deploymentName")
  valid_568552 = validateParameter(valid_568552, JString, required = true,
                                 default = nil)
  if valid_568552 != nil:
    section.add "deploymentName", valid_568552
  var valid_568553 = path.getOrDefault("subscriptionId")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "subscriptionId", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568554 = query.getOrDefault("api-version")
  valid_568554 = validateParameter(valid_568554, JString, required = true,
                                 default = nil)
  if valid_568554 != nil:
    section.add "api-version", valid_568554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568555: Call_DeploymentsDelete_568548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ## 
  let valid = call_568555.validator(path, query, header, formData, body)
  let scheme = call_568555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568555.url(scheme.get, call_568555.host, call_568555.base,
                         call_568555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568555, url, valid)

proc call*(call_568556: Call_DeploymentsDelete_568548; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsDelete
  ## A template deployment that is currently running cannot be deleted. Deleting a template deployment removes the associated deployment operations. Deleting a template deployment does not affect the state of the resource group. This is an asynchronous operation that returns a status of 202 until the template deployment is successfully deleted. The Location response header contains the URI that is used to obtain the status of the process. While the process is running, a call to the URI in the Location header returns a status of 202. When the process finishes, the URI in the Location header returns a status of 204 on success. If the asynchronous request failed, the URI in the Location header returns an error-level status code.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group with the deployment to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to delete.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568557 = newJObject()
  var query_568558 = newJObject()
  add(path_568557, "resourceGroupName", newJString(resourceGroupName))
  add(query_568558, "api-version", newJString(apiVersion))
  add(path_568557, "deploymentName", newJString(deploymentName))
  add(path_568557, "subscriptionId", newJString(subscriptionId))
  result = call_568556.call(path_568557, query_568558, nil, nil, nil)

var deploymentsDelete* = Call_DeploymentsDelete_568548(name: "deploymentsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}",
    validator: validate_DeploymentsDelete_568549, base: "",
    url: url_DeploymentsDelete_568550, schemes: {Scheme.Https})
type
  Call_DeploymentsCancel_568570 = ref object of OpenApiRestCall_567666
proc url_DeploymentsCancel_568572(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsCancel_568571(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment to cancel.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568573 = path.getOrDefault("resourceGroupName")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "resourceGroupName", valid_568573
  var valid_568574 = path.getOrDefault("deploymentName")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "deploymentName", valid_568574
  var valid_568575 = path.getOrDefault("subscriptionId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "subscriptionId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568576 = query.getOrDefault("api-version")
  valid_568576 = validateParameter(valid_568576, JString, required = true,
                                 default = nil)
  if valid_568576 != nil:
    section.add "api-version", valid_568576
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568577: Call_DeploymentsCancel_568570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ## 
  let valid = call_568577.validator(path, query, header, formData, body)
  let scheme = call_568577.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568577.url(scheme.get, call_568577.host, call_568577.base,
                         call_568577.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568577, url, valid)

proc call*(call_568578: Call_DeploymentsCancel_568570; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string): Recallable =
  ## deploymentsCancel
  ## You can cancel a deployment only if the provisioningState is Accepted or Running. After the deployment is canceled, the provisioningState is set to Canceled. Canceling a template deployment stops the currently running template deployment and leaves the resource group partially deployed.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment to cancel.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568579 = newJObject()
  var query_568580 = newJObject()
  add(path_568579, "resourceGroupName", newJString(resourceGroupName))
  add(query_568580, "api-version", newJString(apiVersion))
  add(path_568579, "deploymentName", newJString(deploymentName))
  add(path_568579, "subscriptionId", newJString(subscriptionId))
  result = call_568578.call(path_568579, query_568580, nil, nil, nil)

var deploymentsCancel* = Call_DeploymentsCancel_568570(name: "deploymentsCancel",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/cancel",
    validator: validate_DeploymentsCancel_568571, base: "",
    url: url_DeploymentsCancel_568572, schemes: {Scheme.Https})
type
  Call_DeploymentsExportTemplate_568581 = ref object of OpenApiRestCall_567666
proc url_DeploymentsExportTemplate_568583(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/exportTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsExportTemplate_568582(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports the template used for specified deployment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment from which to get the template.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("deploymentName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "deploymentName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568587 = query.getOrDefault("api-version")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "api-version", valid_568587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568588: Call_DeploymentsExportTemplate_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports the template used for specified deployment.
  ## 
  let valid = call_568588.validator(path, query, header, formData, body)
  let scheme = call_568588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568588.url(scheme.get, call_568588.host, call_568588.base,
                         call_568588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568588, url, valid)

proc call*(call_568589: Call_DeploymentsExportTemplate_568581;
          resourceGroupName: string; apiVersion: string; deploymentName: string;
          subscriptionId: string): Recallable =
  ## deploymentsExportTemplate
  ## Exports the template used for specified deployment.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment from which to get the template.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568590 = newJObject()
  var query_568591 = newJObject()
  add(path_568590, "resourceGroupName", newJString(resourceGroupName))
  add(query_568591, "api-version", newJString(apiVersion))
  add(path_568590, "deploymentName", newJString(deploymentName))
  add(path_568590, "subscriptionId", newJString(subscriptionId))
  result = call_568589.call(path_568590, query_568591, nil, nil, nil)

var deploymentsExportTemplate* = Call_DeploymentsExportTemplate_568581(
    name: "deploymentsExportTemplate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/exportTemplate",
    validator: validate_DeploymentsExportTemplate_568582, base: "",
    url: url_DeploymentsExportTemplate_568583, schemes: {Scheme.Https})
type
  Call_DeploymentsValidate_568592 = ref object of OpenApiRestCall_567666
proc url_DeploymentsValidate_568594(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "deploymentName" in path, "`deploymentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/deployments/"),
               (kind: VariableSegment, value: "deploymentName"),
               (kind: ConstantSegment, value: "/validate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeploymentsValidate_568593(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   deploymentName: JString (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568595 = path.getOrDefault("resourceGroupName")
  valid_568595 = validateParameter(valid_568595, JString, required = true,
                                 default = nil)
  if valid_568595 != nil:
    section.add "resourceGroupName", valid_568595
  var valid_568596 = path.getOrDefault("deploymentName")
  valid_568596 = validateParameter(valid_568596, JString, required = true,
                                 default = nil)
  if valid_568596 != nil:
    section.add "deploymentName", valid_568596
  var valid_568597 = path.getOrDefault("subscriptionId")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "subscriptionId", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568598 = query.getOrDefault("api-version")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "api-version", valid_568598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568600: Call_DeploymentsValidate_568592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ## 
  let valid = call_568600.validator(path, query, header, formData, body)
  let scheme = call_568600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568600.url(scheme.get, call_568600.host, call_568600.base,
                         call_568600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568600, url, valid)

proc call*(call_568601: Call_DeploymentsValidate_568592; resourceGroupName: string;
          apiVersion: string; deploymentName: string; subscriptionId: string;
          parameters: JsonNode): Recallable =
  ## deploymentsValidate
  ## Validates whether the specified template is syntactically correct and will be accepted by Azure Resource Manager..
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group the template will be deployed to. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   deploymentName: string (required)
  ##                 : The name of the deployment.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   parameters: JObject (required)
  ##             : Parameters to validate.
  var path_568602 = newJObject()
  var query_568603 = newJObject()
  var body_568604 = newJObject()
  add(path_568602, "resourceGroupName", newJString(resourceGroupName))
  add(query_568603, "api-version", newJString(apiVersion))
  add(path_568602, "deploymentName", newJString(deploymentName))
  add(path_568602, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568604 = parameters
  result = call_568601.call(path_568602, query_568603, nil, nil, body_568604)

var deploymentsValidate* = Call_DeploymentsValidate_568592(
    name: "deploymentsValidate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.Resources/deployments/{deploymentName}/validate",
    validator: validate_DeploymentsValidate_568593, base: "",
    url: url_DeploymentsValidate_568594, schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdate_568619 = ref object of OpenApiRestCall_567666
proc url_ResourcesCreateOrUpdate_568621(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdate_568620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to create.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568622 = path.getOrDefault("resourceType")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = nil)
  if valid_568622 != nil:
    section.add "resourceType", valid_568622
  var valid_568623 = path.getOrDefault("resourceGroupName")
  valid_568623 = validateParameter(valid_568623, JString, required = true,
                                 default = nil)
  if valid_568623 != nil:
    section.add "resourceGroupName", valid_568623
  var valid_568624 = path.getOrDefault("subscriptionId")
  valid_568624 = validateParameter(valid_568624, JString, required = true,
                                 default = nil)
  if valid_568624 != nil:
    section.add "subscriptionId", valid_568624
  var valid_568625 = path.getOrDefault("resourceName")
  valid_568625 = validateParameter(valid_568625, JString, required = true,
                                 default = nil)
  if valid_568625 != nil:
    section.add "resourceName", valid_568625
  var valid_568626 = path.getOrDefault("resourceProviderNamespace")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "resourceProviderNamespace", valid_568626
  var valid_568627 = path.getOrDefault("parentResourcePath")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "parentResourcePath", valid_568627
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568628 = query.getOrDefault("api-version")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "api-version", valid_568628
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568630: Call_ResourcesCreateOrUpdate_568619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a resource.
  ## 
  let valid = call_568630.validator(path, query, header, formData, body)
  let scheme = call_568630.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568630.url(scheme.get, call_568630.host, call_568630.base,
                         call_568630.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568630, url, valid)

proc call*(call_568631: Call_ResourcesCreateOrUpdate_568619; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesCreateOrUpdate
  ## Creates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to create.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to create.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568632 = newJObject()
  var query_568633 = newJObject()
  var body_568634 = newJObject()
  add(path_568632, "resourceType", newJString(resourceType))
  add(path_568632, "resourceGroupName", newJString(resourceGroupName))
  add(query_568633, "api-version", newJString(apiVersion))
  add(path_568632, "subscriptionId", newJString(subscriptionId))
  add(path_568632, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568634 = parameters
  add(path_568632, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568632, "parentResourcePath", newJString(parentResourcePath))
  result = call_568631.call(path_568632, query_568633, nil, nil, body_568634)

var resourcesCreateOrUpdate* = Call_ResourcesCreateOrUpdate_568619(
    name: "resourcesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCreateOrUpdate_568620, base: "",
    url: url_ResourcesCreateOrUpdate_568621, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistence_568649 = ref object of OpenApiRestCall_567666
proc url_ResourcesCheckExistence_568651(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistence_568650(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568652 = path.getOrDefault("resourceType")
  valid_568652 = validateParameter(valid_568652, JString, required = true,
                                 default = nil)
  if valid_568652 != nil:
    section.add "resourceType", valid_568652
  var valid_568653 = path.getOrDefault("resourceGroupName")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "resourceGroupName", valid_568653
  var valid_568654 = path.getOrDefault("subscriptionId")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "subscriptionId", valid_568654
  var valid_568655 = path.getOrDefault("resourceName")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "resourceName", valid_568655
  var valid_568656 = path.getOrDefault("resourceProviderNamespace")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "resourceProviderNamespace", valid_568656
  var valid_568657 = path.getOrDefault("parentResourcePath")
  valid_568657 = validateParameter(valid_568657, JString, required = true,
                                 default = nil)
  if valid_568657 != nil:
    section.add "parentResourcePath", valid_568657
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568658 = query.getOrDefault("api-version")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "api-version", valid_568658
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568659: Call_ResourcesCheckExistence_568649; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether a resource exists.
  ## 
  let valid = call_568659.validator(path, query, header, formData, body)
  let scheme = call_568659.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568659.url(scheme.get, call_568659.host, call_568659.base,
                         call_568659.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568659, url, valid)

proc call*(call_568660: Call_ResourcesCheckExistence_568649; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesCheckExistence
  ## Checks whether a resource exists.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to check. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to check whether it exists.
  ##   resourceProviderNamespace: string (required)
  ##                            : The resource provider of the resource to check.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568661 = newJObject()
  var query_568662 = newJObject()
  add(path_568661, "resourceType", newJString(resourceType))
  add(path_568661, "resourceGroupName", newJString(resourceGroupName))
  add(query_568662, "api-version", newJString(apiVersion))
  add(path_568661, "subscriptionId", newJString(subscriptionId))
  add(path_568661, "resourceName", newJString(resourceName))
  add(path_568661, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568661, "parentResourcePath", newJString(parentResourcePath))
  result = call_568660.call(path_568661, query_568662, nil, nil, nil)

var resourcesCheckExistence* = Call_ResourcesCheckExistence_568649(
    name: "resourcesCheckExistence", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesCheckExistence_568650, base: "",
    url: url_ResourcesCheckExistence_568651, schemes: {Scheme.Https})
type
  Call_ResourcesGet_568605 = ref object of OpenApiRestCall_567666
proc url_ResourcesGet_568607(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGet_568606(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568608 = path.getOrDefault("resourceType")
  valid_568608 = validateParameter(valid_568608, JString, required = true,
                                 default = nil)
  if valid_568608 != nil:
    section.add "resourceType", valid_568608
  var valid_568609 = path.getOrDefault("resourceGroupName")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "resourceGroupName", valid_568609
  var valid_568610 = path.getOrDefault("subscriptionId")
  valid_568610 = validateParameter(valid_568610, JString, required = true,
                                 default = nil)
  if valid_568610 != nil:
    section.add "subscriptionId", valid_568610
  var valid_568611 = path.getOrDefault("resourceName")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = nil)
  if valid_568611 != nil:
    section.add "resourceName", valid_568611
  var valid_568612 = path.getOrDefault("resourceProviderNamespace")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "resourceProviderNamespace", valid_568612
  var valid_568613 = path.getOrDefault("parentResourcePath")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "parentResourcePath", valid_568613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568614 = query.getOrDefault("api-version")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "api-version", valid_568614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568615: Call_ResourcesGet_568605; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource.
  ## 
  let valid = call_568615.validator(path, query, header, formData, body)
  let scheme = call_568615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568615.url(scheme.get, call_568615.host, call_568615.base,
                         call_568615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568615, url, valid)

proc call*(call_568616: Call_ResourcesGet_568605; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesGet
  ## Gets a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group containing the resource to get. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to get.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568617 = newJObject()
  var query_568618 = newJObject()
  add(path_568617, "resourceType", newJString(resourceType))
  add(path_568617, "resourceGroupName", newJString(resourceGroupName))
  add(query_568618, "api-version", newJString(apiVersion))
  add(path_568617, "subscriptionId", newJString(subscriptionId))
  add(path_568617, "resourceName", newJString(resourceName))
  add(path_568617, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568617, "parentResourcePath", newJString(parentResourcePath))
  result = call_568616.call(path_568617, query_568618, nil, nil, nil)

var resourcesGet* = Call_ResourcesGet_568605(name: "resourcesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesGet_568606, base: "", url: url_ResourcesGet_568607,
    schemes: {Scheme.Https})
type
  Call_ResourcesUpdate_568663 = ref object of OpenApiRestCall_567666
proc url_ResourcesUpdate_568665(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdate_568664(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to update.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568666 = path.getOrDefault("resourceType")
  valid_568666 = validateParameter(valid_568666, JString, required = true,
                                 default = nil)
  if valid_568666 != nil:
    section.add "resourceType", valid_568666
  var valid_568667 = path.getOrDefault("resourceGroupName")
  valid_568667 = validateParameter(valid_568667, JString, required = true,
                                 default = nil)
  if valid_568667 != nil:
    section.add "resourceGroupName", valid_568667
  var valid_568668 = path.getOrDefault("subscriptionId")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "subscriptionId", valid_568668
  var valid_568669 = path.getOrDefault("resourceName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "resourceName", valid_568669
  var valid_568670 = path.getOrDefault("resourceProviderNamespace")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "resourceProviderNamespace", valid_568670
  var valid_568671 = path.getOrDefault("parentResourcePath")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "parentResourcePath", valid_568671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568672 = query.getOrDefault("api-version")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "api-version", valid_568672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568674: Call_ResourcesUpdate_568663; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource.
  ## 
  let valid = call_568674.validator(path, query, header, formData, body)
  let scheme = call_568674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568674.url(scheme.get, call_568674.host, call_568674.base,
                         call_568674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568674, url, valid)

proc call*(call_568675: Call_ResourcesUpdate_568663; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; parameters: JsonNode;
          resourceProviderNamespace: string; parentResourcePath: string): Recallable =
  ## resourcesUpdate
  ## Updates a resource.
  ##   resourceType: string (required)
  ##               : The resource type of the resource to update.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group for the resource. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to update.
  ##   parameters: JObject (required)
  ##             : Parameters for updating the resource.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568676 = newJObject()
  var query_568677 = newJObject()
  var body_568678 = newJObject()
  add(path_568676, "resourceType", newJString(resourceType))
  add(path_568676, "resourceGroupName", newJString(resourceGroupName))
  add(query_568677, "api-version", newJString(apiVersion))
  add(path_568676, "subscriptionId", newJString(subscriptionId))
  add(path_568676, "resourceName", newJString(resourceName))
  if parameters != nil:
    body_568678 = parameters
  add(path_568676, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568676, "parentResourcePath", newJString(parentResourcePath))
  result = call_568675.call(path_568676, query_568677, nil, nil, body_568678)

var resourcesUpdate* = Call_ResourcesUpdate_568663(name: "resourcesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesUpdate_568664, base: "", url: url_ResourcesUpdate_568665,
    schemes: {Scheme.Https})
type
  Call_ResourcesDelete_568635 = ref object of OpenApiRestCall_567666
proc url_ResourcesDelete_568637(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceProviderNamespace" in path,
        "`resourceProviderNamespace` is a required path parameter"
  assert "parentResourcePath" in path,
        "`parentResourcePath` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceProviderNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "parentResourcePath"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDelete_568636(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The resource type.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: JString (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: JString (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: JString (required)
  ##                     : The parent resource identity.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568638 = path.getOrDefault("resourceType")
  valid_568638 = validateParameter(valid_568638, JString, required = true,
                                 default = nil)
  if valid_568638 != nil:
    section.add "resourceType", valid_568638
  var valid_568639 = path.getOrDefault("resourceGroupName")
  valid_568639 = validateParameter(valid_568639, JString, required = true,
                                 default = nil)
  if valid_568639 != nil:
    section.add "resourceGroupName", valid_568639
  var valid_568640 = path.getOrDefault("subscriptionId")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "subscriptionId", valid_568640
  var valid_568641 = path.getOrDefault("resourceName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "resourceName", valid_568641
  var valid_568642 = path.getOrDefault("resourceProviderNamespace")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "resourceProviderNamespace", valid_568642
  var valid_568643 = path.getOrDefault("parentResourcePath")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "parentResourcePath", valid_568643
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568644 = query.getOrDefault("api-version")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "api-version", valid_568644
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568645: Call_ResourcesDelete_568635; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource.
  ## 
  let valid = call_568645.validator(path, query, header, formData, body)
  let scheme = call_568645.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568645.url(scheme.get, call_568645.host, call_568645.base,
                         call_568645.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568645, url, valid)

proc call*(call_568646: Call_ResourcesDelete_568635; resourceType: string;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          resourceName: string; resourceProviderNamespace: string;
          parentResourcePath: string): Recallable =
  ## resourcesDelete
  ## Deletes a resource.
  ##   resourceType: string (required)
  ##               : The resource type.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource to delete. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   resourceName: string (required)
  ##               : The name of the resource to delete.
  ##   resourceProviderNamespace: string (required)
  ##                            : The namespace of the resource provider.
  ##   parentResourcePath: string (required)
  ##                     : The parent resource identity.
  var path_568647 = newJObject()
  var query_568648 = newJObject()
  add(path_568647, "resourceType", newJString(resourceType))
  add(path_568647, "resourceGroupName", newJString(resourceGroupName))
  add(query_568648, "api-version", newJString(apiVersion))
  add(path_568647, "subscriptionId", newJString(subscriptionId))
  add(path_568647, "resourceName", newJString(resourceName))
  add(path_568647, "resourceProviderNamespace",
      newJString(resourceProviderNamespace))
  add(path_568647, "parentResourcePath", newJString(parentResourcePath))
  result = call_568646.call(path_568647, query_568648, nil, nil, nil)

var resourcesDelete* = Call_ResourcesDelete_568635(name: "resourcesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{resourceProviderNamespace}/{parentResourcePath}/{resourceType}/{resourceName}",
    validator: validate_ResourcesDelete_568636, base: "", url: url_ResourcesDelete_568637,
    schemes: {Scheme.Https})
type
  Call_ResourcesList_568679 = ref object of OpenApiRestCall_567666
proc url_ResourcesList_568681(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesList_568680(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the resources in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568682 = path.getOrDefault("subscriptionId")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "subscriptionId", valid_568682
  result.add "path", section
  ## parameters in `query` object:
  ##   $expand: JString
  ##          : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  ##   $top: JInt
  ##       : The number of results to return. If null is passed, returns all resource groups.
  ##   $filter: JString
  ##          : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  section = newJObject()
  var valid_568683 = query.getOrDefault("$expand")
  valid_568683 = validateParameter(valid_568683, JString, required = false,
                                 default = nil)
  if valid_568683 != nil:
    section.add "$expand", valid_568683
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568684 = query.getOrDefault("api-version")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "api-version", valid_568684
  var valid_568685 = query.getOrDefault("$top")
  valid_568685 = validateParameter(valid_568685, JInt, required = false, default = nil)
  if valid_568685 != nil:
    section.add "$top", valid_568685
  var valid_568686 = query.getOrDefault("$filter")
  valid_568686 = validateParameter(valid_568686, JString, required = false,
                                 default = nil)
  if valid_568686 != nil:
    section.add "$filter", valid_568686
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568687: Call_ResourcesList_568679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the resources in a subscription.
  ## 
  let valid = call_568687.validator(path, query, header, formData, body)
  let scheme = call_568687.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568687.url(scheme.get, call_568687.host, call_568687.base,
                         call_568687.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568687, url, valid)

proc call*(call_568688: Call_ResourcesList_568679; apiVersion: string;
          subscriptionId: string; Expand: string = ""; Top: int = 0; Filter: string = ""): Recallable =
  ## resourcesList
  ## Get all the resources in a subscription.
  ##   Expand: string
  ##         : The $expand query parameter. You can expand createdTime and changedTime. For example, to expand both properties, use $expand=changedTime,createdTime
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Top: int
  ##      : The number of results to return. If null is passed, returns all resource groups.
  ##   Filter: string
  ##         : The filter to apply on the operation.<br><br>The properties you can use for eq (equals) or ne (not equals) are: location, resourceType, name, resourceGroup, identity, identity/principalId, plan, plan/publisher, plan/product, plan/name, plan/version, and plan/promotionCode.<br><br>For example, to filter by a resource type, use: $filter=resourceType eq 'Microsoft.Network/virtualNetworks'<br><br>You can use substringof(value, property) in the filter. The properties you can use for substring are: name and resourceGroup.<br><br>For example, to get all resources with 'demo' anywhere in the name, use: $filter=substringof('demo', name)<br><br>You can link more than one substringof together by adding and/or operators.<br><br>You can filter by tag names and values. For example, to filter for a tag name and value, use $filter=tagName eq 'tag1' and tagValue eq 'Value1'<br><br>You can use some properties together when filtering. The combinations you can use are: substringof and/or resourceType, plan and plan/publisher and plan/name, identity and identity/principalId.
  var path_568689 = newJObject()
  var query_568690 = newJObject()
  add(query_568690, "$expand", newJString(Expand))
  add(query_568690, "api-version", newJString(apiVersion))
  add(path_568689, "subscriptionId", newJString(subscriptionId))
  add(query_568690, "$top", newJInt(Top))
  add(query_568690, "$filter", newJString(Filter))
  result = call_568688.call(path_568689, query_568690, nil, nil, nil)

var resourcesList* = Call_ResourcesList_568679(name: "resourcesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/resources",
    validator: validate_ResourcesList_568680, base: "", url: url_ResourcesList_568681,
    schemes: {Scheme.Https})
type
  Call_TagsList_568691 = ref object of OpenApiRestCall_567666
proc url_TagsList_568693(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsList_568692(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568694 = path.getOrDefault("subscriptionId")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = nil)
  if valid_568694 != nil:
    section.add "subscriptionId", valid_568694
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568695 = query.getOrDefault("api-version")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "api-version", valid_568695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568696: Call_TagsList_568691; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ## 
  let valid = call_568696.validator(path, query, header, formData, body)
  let scheme = call_568696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568696.url(scheme.get, call_568696.host, call_568696.base,
                         call_568696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568696, url, valid)

proc call*(call_568697: Call_TagsList_568691; apiVersion: string;
          subscriptionId: string): Recallable =
  ## tagsList
  ## Gets the names and values of all resource tags that are defined in a subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568698 = newJObject()
  var query_568699 = newJObject()
  add(query_568699, "api-version", newJString(apiVersion))
  add(path_568698, "subscriptionId", newJString(subscriptionId))
  result = call_568697.call(path_568698, query_568699, nil, nil, nil)

var tagsList* = Call_TagsList_568691(name: "tagsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames",
                                  validator: validate_TagsList_568692, base: "",
                                  url: url_TagsList_568693,
                                  schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdate_568700 = ref object of OpenApiRestCall_567666
proc url_TagsCreateOrUpdate_568702(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdate_568701(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568703 = path.getOrDefault("tagName")
  valid_568703 = validateParameter(valid_568703, JString, required = true,
                                 default = nil)
  if valid_568703 != nil:
    section.add "tagName", valid_568703
  var valid_568704 = path.getOrDefault("subscriptionId")
  valid_568704 = validateParameter(valid_568704, JString, required = true,
                                 default = nil)
  if valid_568704 != nil:
    section.add "subscriptionId", valid_568704
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568705 = query.getOrDefault("api-version")
  valid_568705 = validateParameter(valid_568705, JString, required = true,
                                 default = nil)
  if valid_568705 != nil:
    section.add "api-version", valid_568705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568706: Call_TagsCreateOrUpdate_568700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ## 
  let valid = call_568706.validator(path, query, header, formData, body)
  let scheme = call_568706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568706.url(scheme.get, call_568706.host, call_568706.base,
                         call_568706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568706, url, valid)

proc call*(call_568707: Call_TagsCreateOrUpdate_568700; apiVersion: string;
          tagName: string; subscriptionId: string): Recallable =
  ## tagsCreateOrUpdate
  ## The tag name can have a maximum of 512 characters and is case insensitive. Tag names created by Azure have prefixes of microsoft, azure, or windows. You cannot create tags with one of these prefixes.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag to create.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568708 = newJObject()
  var query_568709 = newJObject()
  add(query_568709, "api-version", newJString(apiVersion))
  add(path_568708, "tagName", newJString(tagName))
  add(path_568708, "subscriptionId", newJString(subscriptionId))
  result = call_568707.call(path_568708, query_568709, nil, nil, nil)

var tagsCreateOrUpdate* = Call_TagsCreateOrUpdate_568700(
    name: "tagsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
    validator: validate_TagsCreateOrUpdate_568701, base: "",
    url: url_TagsCreateOrUpdate_568702, schemes: {Scheme.Https})
type
  Call_TagsDelete_568710 = ref object of OpenApiRestCall_567666
proc url_TagsDelete_568712(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDelete_568711(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568713 = path.getOrDefault("tagName")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "tagName", valid_568713
  var valid_568714 = path.getOrDefault("subscriptionId")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "subscriptionId", valid_568714
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568715 = query.getOrDefault("api-version")
  valid_568715 = validateParameter(valid_568715, JString, required = true,
                                 default = nil)
  if valid_568715 != nil:
    section.add "api-version", valid_568715
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568716: Call_TagsDelete_568710; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You must remove all values from a resource tag before you can delete it.
  ## 
  let valid = call_568716.validator(path, query, header, formData, body)
  let scheme = call_568716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568716.url(scheme.get, call_568716.host, call_568716.base,
                         call_568716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568716, url, valid)

proc call*(call_568717: Call_TagsDelete_568710; apiVersion: string; tagName: string;
          subscriptionId: string): Recallable =
  ## tagsDelete
  ## You must remove all values from a resource tag before you can delete it.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_568718 = newJObject()
  var query_568719 = newJObject()
  add(query_568719, "api-version", newJString(apiVersion))
  add(path_568718, "tagName", newJString(tagName))
  add(path_568718, "subscriptionId", newJString(subscriptionId))
  result = call_568717.call(path_568718, query_568719, nil, nil, nil)

var tagsDelete* = Call_TagsDelete_568710(name: "tagsDelete",
                                      meth: HttpMethod.HttpDelete,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}",
                                      validator: validate_TagsDelete_568711,
                                      base: "", url: url_TagsDelete_568712,
                                      schemes: {Scheme.Https})
type
  Call_TagsCreateOrUpdateValue_568720 = ref object of OpenApiRestCall_567666
proc url_TagsCreateOrUpdateValue_568722(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsCreateOrUpdateValue_568721(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568723 = path.getOrDefault("tagName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "tagName", valid_568723
  var valid_568724 = path.getOrDefault("subscriptionId")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "subscriptionId", valid_568724
  var valid_568725 = path.getOrDefault("tagValue")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "tagValue", valid_568725
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568726 = query.getOrDefault("api-version")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "api-version", valid_568726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568727: Call_TagsCreateOrUpdateValue_568720; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a tag value. The name of the tag must already exist.
  ## 
  let valid = call_568727.validator(path, query, header, formData, body)
  let scheme = call_568727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568727.url(scheme.get, call_568727.host, call_568727.base,
                         call_568727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568727, url, valid)

proc call*(call_568728: Call_TagsCreateOrUpdateValue_568720; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsCreateOrUpdateValue
  ## Creates a tag value. The name of the tag must already exist.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to create.
  var path_568729 = newJObject()
  var query_568730 = newJObject()
  add(query_568730, "api-version", newJString(apiVersion))
  add(path_568729, "tagName", newJString(tagName))
  add(path_568729, "subscriptionId", newJString(subscriptionId))
  add(path_568729, "tagValue", newJString(tagValue))
  result = call_568728.call(path_568729, query_568730, nil, nil, nil)

var tagsCreateOrUpdateValue* = Call_TagsCreateOrUpdateValue_568720(
    name: "tagsCreateOrUpdateValue", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsCreateOrUpdateValue_568721, base: "",
    url: url_TagsCreateOrUpdateValue_568722, schemes: {Scheme.Https})
type
  Call_TagsDeleteValue_568731 = ref object of OpenApiRestCall_567666
proc url_TagsDeleteValue_568733(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "tagName" in path, "`tagName` is a required path parameter"
  assert "tagValue" in path, "`tagValue` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/tagNames/"),
               (kind: VariableSegment, value: "tagName"),
               (kind: ConstantSegment, value: "/tagValues/"),
               (kind: VariableSegment, value: "tagValue")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_TagsDeleteValue_568732(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes a tag value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tagName: JString (required)
  ##          : The name of the tag.
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: JString (required)
  ##           : The value of the tag to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tagName` field"
  var valid_568734 = path.getOrDefault("tagName")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "tagName", valid_568734
  var valid_568735 = path.getOrDefault("subscriptionId")
  valid_568735 = validateParameter(valid_568735, JString, required = true,
                                 default = nil)
  if valid_568735 != nil:
    section.add "subscriptionId", valid_568735
  var valid_568736 = path.getOrDefault("tagValue")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "tagValue", valid_568736
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568737 = query.getOrDefault("api-version")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "api-version", valid_568737
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568738: Call_TagsDeleteValue_568731; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a tag value.
  ## 
  let valid = call_568738.validator(path, query, header, formData, body)
  let scheme = call_568738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568738.url(scheme.get, call_568738.host, call_568738.base,
                         call_568738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568738, url, valid)

proc call*(call_568739: Call_TagsDeleteValue_568731; apiVersion: string;
          tagName: string; subscriptionId: string; tagValue: string): Recallable =
  ## tagsDeleteValue
  ## Deletes a tag value.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   tagName: string (required)
  ##          : The name of the tag.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   tagValue: string (required)
  ##           : The value of the tag to delete.
  var path_568740 = newJObject()
  var query_568741 = newJObject()
  add(query_568741, "api-version", newJString(apiVersion))
  add(path_568740, "tagName", newJString(tagName))
  add(path_568740, "subscriptionId", newJString(subscriptionId))
  add(path_568740, "tagValue", newJString(tagValue))
  result = call_568739.call(path_568740, query_568741, nil, nil, nil)

var tagsDeleteValue* = Call_TagsDeleteValue_568731(name: "tagsDeleteValue",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/tagNames/{tagName}/tagValues/{tagValue}",
    validator: validate_TagsDeleteValue_568732, base: "", url: url_TagsDeleteValue_568733,
    schemes: {Scheme.Https})
type
  Call_ResourcesCreateOrUpdateById_568751 = ref object of OpenApiRestCall_567666
proc url_ResourcesCreateOrUpdateById_568753(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCreateOrUpdateById_568752(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568754 = path.getOrDefault("resourceId")
  valid_568754 = validateParameter(valid_568754, JString, required = true,
                                 default = nil)
  if valid_568754 != nil:
    section.add "resourceId", valid_568754
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568755 = query.getOrDefault("api-version")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "api-version", valid_568755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568757: Call_ResourcesCreateOrUpdateById_568751; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a resource by ID.
  ## 
  let valid = call_568757.validator(path, query, header, formData, body)
  let scheme = call_568757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568757.url(scheme.get, call_568757.host, call_568757.base,
                         call_568757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568757, url, valid)

proc call*(call_568758: Call_ResourcesCreateOrUpdateById_568751;
          apiVersion: string; resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesCreateOrUpdateById
  ## Create a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Create or update resource parameters.
  var path_568759 = newJObject()
  var query_568760 = newJObject()
  var body_568761 = newJObject()
  add(query_568760, "api-version", newJString(apiVersion))
  add(path_568759, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568761 = parameters
  result = call_568758.call(path_568759, query_568760, nil, nil, body_568761)

var resourcesCreateOrUpdateById* = Call_ResourcesCreateOrUpdateById_568751(
    name: "resourcesCreateOrUpdateById", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCreateOrUpdateById_568752, base: "",
    url: url_ResourcesCreateOrUpdateById_568753, schemes: {Scheme.Https})
type
  Call_ResourcesCheckExistenceById_568771 = ref object of OpenApiRestCall_567666
proc url_ResourcesCheckExistenceById_568773(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesCheckExistenceById_568772(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks by ID whether a resource exists.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568774 = path.getOrDefault("resourceId")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "resourceId", valid_568774
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568775 = query.getOrDefault("api-version")
  valid_568775 = validateParameter(valid_568775, JString, required = true,
                                 default = nil)
  if valid_568775 != nil:
    section.add "api-version", valid_568775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568776: Call_ResourcesCheckExistenceById_568771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks by ID whether a resource exists.
  ## 
  let valid = call_568776.validator(path, query, header, formData, body)
  let scheme = call_568776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568776.url(scheme.get, call_568776.host, call_568776.base,
                         call_568776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568776, url, valid)

proc call*(call_568777: Call_ResourcesCheckExistenceById_568771;
          apiVersion: string; resourceId: string): Recallable =
  ## resourcesCheckExistenceById
  ## Checks by ID whether a resource exists.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568778 = newJObject()
  var query_568779 = newJObject()
  add(query_568779, "api-version", newJString(apiVersion))
  add(path_568778, "resourceId", newJString(resourceId))
  result = call_568777.call(path_568778, query_568779, nil, nil, nil)

var resourcesCheckExistenceById* = Call_ResourcesCheckExistenceById_568771(
    name: "resourcesCheckExistenceById", meth: HttpMethod.HttpHead,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesCheckExistenceById_568772, base: "",
    url: url_ResourcesCheckExistenceById_568773, schemes: {Scheme.Https})
type
  Call_ResourcesGetById_568742 = ref object of OpenApiRestCall_567666
proc url_ResourcesGetById_568744(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesGetById_568743(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568745 = path.getOrDefault("resourceId")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = nil)
  if valid_568745 != nil:
    section.add "resourceId", valid_568745
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568746 = query.getOrDefault("api-version")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = nil)
  if valid_568746 != nil:
    section.add "api-version", valid_568746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568747: Call_ResourcesGetById_568742; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource by ID.
  ## 
  let valid = call_568747.validator(path, query, header, formData, body)
  let scheme = call_568747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568747.url(scheme.get, call_568747.host, call_568747.base,
                         call_568747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568747, url, valid)

proc call*(call_568748: Call_ResourcesGetById_568742; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesGetById
  ## Gets a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568749 = newJObject()
  var query_568750 = newJObject()
  add(query_568750, "api-version", newJString(apiVersion))
  add(path_568749, "resourceId", newJString(resourceId))
  result = call_568748.call(path_568749, query_568750, nil, nil, nil)

var resourcesGetById* = Call_ResourcesGetById_568742(name: "resourcesGetById",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesGetById_568743, base: "",
    url: url_ResourcesGetById_568744, schemes: {Scheme.Https})
type
  Call_ResourcesUpdateById_568780 = ref object of OpenApiRestCall_567666
proc url_ResourcesUpdateById_568782(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesUpdateById_568781(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568783 = path.getOrDefault("resourceId")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = nil)
  if valid_568783 != nil:
    section.add "resourceId", valid_568783
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568784 = query.getOrDefault("api-version")
  valid_568784 = validateParameter(valid_568784, JString, required = true,
                                 default = nil)
  if valid_568784 != nil:
    section.add "api-version", valid_568784
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568786: Call_ResourcesUpdateById_568780; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a resource by ID.
  ## 
  let valid = call_568786.validator(path, query, header, formData, body)
  let scheme = call_568786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568786.url(scheme.get, call_568786.host, call_568786.base,
                         call_568786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568786, url, valid)

proc call*(call_568787: Call_ResourcesUpdateById_568780; apiVersion: string;
          resourceId: string; parameters: JsonNode): Recallable =
  ## resourcesUpdateById
  ## Updates a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  ##   parameters: JObject (required)
  ##             : Update resource parameters.
  var path_568788 = newJObject()
  var query_568789 = newJObject()
  var body_568790 = newJObject()
  add(query_568789, "api-version", newJString(apiVersion))
  add(path_568788, "resourceId", newJString(resourceId))
  if parameters != nil:
    body_568790 = parameters
  result = call_568787.call(path_568788, query_568789, nil, nil, body_568790)

var resourcesUpdateById* = Call_ResourcesUpdateById_568780(
    name: "resourcesUpdateById", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesUpdateById_568781, base: "",
    url: url_ResourcesUpdateById_568782, schemes: {Scheme.Https})
type
  Call_ResourcesDeleteById_568762 = ref object of OpenApiRestCall_567666
proc url_ResourcesDeleteById_568764(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourcesDeleteById_568763(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a resource by ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceId: JString (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceId` field"
  var valid_568765 = path.getOrDefault("resourceId")
  valid_568765 = validateParameter(valid_568765, JString, required = true,
                                 default = nil)
  if valid_568765 != nil:
    section.add "resourceId", valid_568765
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568766 = query.getOrDefault("api-version")
  valid_568766 = validateParameter(valid_568766, JString, required = true,
                                 default = nil)
  if valid_568766 != nil:
    section.add "api-version", valid_568766
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568767: Call_ResourcesDeleteById_568762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource by ID.
  ## 
  let valid = call_568767.validator(path, query, header, formData, body)
  let scheme = call_568767.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568767.url(scheme.get, call_568767.host, call_568767.base,
                         call_568767.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568767, url, valid)

proc call*(call_568768: Call_ResourcesDeleteById_568762; apiVersion: string;
          resourceId: string): Recallable =
  ## resourcesDeleteById
  ## Deletes a resource by ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   resourceId: string (required)
  ##             : The fully qualified ID of the resource, including the resource name and resource type. Use the format, 
  ## /subscriptions/{guid}/resourceGroups/{resource-group-name}/{resource-provider-namespace}/{resource-type}/{resource-name}
  var path_568769 = newJObject()
  var query_568770 = newJObject()
  add(query_568770, "api-version", newJString(apiVersion))
  add(path_568769, "resourceId", newJString(resourceId))
  result = call_568768.call(path_568769, query_568770, nil, nil, nil)

var resourcesDeleteById* = Call_ResourcesDeleteById_568762(
    name: "resourcesDeleteById", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{resourceId}",
    validator: validate_ResourcesDeleteById_568763, base: "",
    url: url_ResourcesDeleteById_568764, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

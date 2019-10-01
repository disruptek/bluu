
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure SQL Database Datamasking Policies and Rules
## version: 2014-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides create, read, update and delete functionality for Azure SQL Database datamasking policies and rules.
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "sql-dataMasking"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DataMaskingPoliciesCreateOrUpdate_568193 = ref object of OpenApiRestCall_567642
proc url_DataMaskingPoliciesCreateOrUpdate_568195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataMaskingPolicyName" in path,
        "`dataMaskingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataMaskingPolicies/"),
               (kind: VariableSegment, value: "dataMaskingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataMaskingPoliciesCreateOrUpdate_568194(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database data masking policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: JString (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568213 = path.getOrDefault("resourceGroupName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "resourceGroupName", valid_568213
  var valid_568214 = path.getOrDefault("serverName")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "serverName", valid_568214
  var valid_568215 = path.getOrDefault("dataMaskingPolicyName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = newJString("Default"))
  if valid_568215 != nil:
    section.add "dataMaskingPolicyName", valid_568215
  var valid_568216 = path.getOrDefault("subscriptionId")
  valid_568216 = validateParameter(valid_568216, JString, required = true,
                                 default = nil)
  if valid_568216 != nil:
    section.add "subscriptionId", valid_568216
  var valid_568217 = path.getOrDefault("databaseName")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = nil)
  if valid_568217 != nil:
    section.add "databaseName", valid_568217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568218 = query.getOrDefault("api-version")
  valid_568218 = validateParameter(valid_568218, JString, required = true,
                                 default = nil)
  if valid_568218 != nil:
    section.add "api-version", valid_568218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a data masking policy.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568220: Call_DataMaskingPoliciesCreateOrUpdate_568193;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates a database data masking policy
  ## 
  let valid = call_568220.validator(path, query, header, formData, body)
  let scheme = call_568220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568220.url(scheme.get, call_568220.host, call_568220.base,
                         call_568220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568220, url, valid)

proc call*(call_568221: Call_DataMaskingPoliciesCreateOrUpdate_568193;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode;
          dataMaskingPolicyName: string = "Default"): Recallable =
  ## dataMaskingPoliciesCreateOrUpdate
  ## Creates or updates a database data masking policy
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: string (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a data masking policy.
  var path_568222 = newJObject()
  var query_568223 = newJObject()
  var body_568224 = newJObject()
  add(path_568222, "resourceGroupName", newJString(resourceGroupName))
  add(query_568223, "api-version", newJString(apiVersion))
  add(path_568222, "serverName", newJString(serverName))
  add(path_568222, "dataMaskingPolicyName", newJString(dataMaskingPolicyName))
  add(path_568222, "subscriptionId", newJString(subscriptionId))
  add(path_568222, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568224 = parameters
  result = call_568221.call(path_568222, query_568223, nil, nil, body_568224)

var dataMaskingPoliciesCreateOrUpdate* = Call_DataMaskingPoliciesCreateOrUpdate_568193(
    name: "dataMaskingPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/dataMaskingPolicies/{dataMaskingPolicyName}",
    validator: validate_DataMaskingPoliciesCreateOrUpdate_568194, base: "",
    url: url_DataMaskingPoliciesCreateOrUpdate_568195, schemes: {Scheme.Https})
type
  Call_DataMaskingPoliciesGet_567864 = ref object of OpenApiRestCall_567642
proc url_DataMaskingPoliciesGet_567866(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataMaskingPolicyName" in path,
        "`dataMaskingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataMaskingPolicies/"),
               (kind: VariableSegment, value: "dataMaskingPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataMaskingPoliciesGet_567865(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a database data masking policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: JString (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568039 = path.getOrDefault("resourceGroupName")
  valid_568039 = validateParameter(valid_568039, JString, required = true,
                                 default = nil)
  if valid_568039 != nil:
    section.add "resourceGroupName", valid_568039
  var valid_568040 = path.getOrDefault("serverName")
  valid_568040 = validateParameter(valid_568040, JString, required = true,
                                 default = nil)
  if valid_568040 != nil:
    section.add "serverName", valid_568040
  var valid_568054 = path.getOrDefault("dataMaskingPolicyName")
  valid_568054 = validateParameter(valid_568054, JString, required = true,
                                 default = newJString("Default"))
  if valid_568054 != nil:
    section.add "dataMaskingPolicyName", valid_568054
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  var valid_568056 = path.getOrDefault("databaseName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "databaseName", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568080: Call_DataMaskingPoliciesGet_567864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a database data masking policy.
  ## 
  let valid = call_568080.validator(path, query, header, formData, body)
  let scheme = call_568080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568080.url(scheme.get, call_568080.host, call_568080.base,
                         call_568080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568080, url, valid)

proc call*(call_568151: Call_DataMaskingPoliciesGet_567864;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string;
          dataMaskingPolicyName: string = "Default"): Recallable =
  ## dataMaskingPoliciesGet
  ## Gets a database data masking policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: string (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568152 = newJObject()
  var query_568154 = newJObject()
  add(path_568152, "resourceGroupName", newJString(resourceGroupName))
  add(query_568154, "api-version", newJString(apiVersion))
  add(path_568152, "serverName", newJString(serverName))
  add(path_568152, "dataMaskingPolicyName", newJString(dataMaskingPolicyName))
  add(path_568152, "subscriptionId", newJString(subscriptionId))
  add(path_568152, "databaseName", newJString(databaseName))
  result = call_568151.call(path_568152, query_568154, nil, nil, nil)

var dataMaskingPoliciesGet* = Call_DataMaskingPoliciesGet_567864(
    name: "dataMaskingPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/dataMaskingPolicies/{dataMaskingPolicyName}",
    validator: validate_DataMaskingPoliciesGet_567865, base: "",
    url: url_DataMaskingPoliciesGet_567866, schemes: {Scheme.Https})
type
  Call_DataMaskingRulesListByDatabase_568225 = ref object of OpenApiRestCall_567642
proc url_DataMaskingRulesListByDatabase_568227(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataMaskingPolicyName" in path,
        "`dataMaskingPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataMaskingPolicies/"),
               (kind: VariableSegment, value: "dataMaskingPolicyName"),
               (kind: ConstantSegment, value: "/rules")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataMaskingRulesListByDatabase_568226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of database data masking rules.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: JString (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568228 = path.getOrDefault("resourceGroupName")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "resourceGroupName", valid_568228
  var valid_568229 = path.getOrDefault("serverName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "serverName", valid_568229
  var valid_568230 = path.getOrDefault("dataMaskingPolicyName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = newJString("Default"))
  if valid_568230 != nil:
    section.add "dataMaskingPolicyName", valid_568230
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  var valid_568232 = path.getOrDefault("databaseName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "databaseName", valid_568232
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568233 = query.getOrDefault("api-version")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "api-version", valid_568233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_DataMaskingRulesListByDatabase_568225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of database data masking rules.
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_DataMaskingRulesListByDatabase_568225;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string;
          dataMaskingPolicyName: string = "Default"): Recallable =
  ## dataMaskingRulesListByDatabase
  ## Gets a list of database data masking rules.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: string (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  add(path_568236, "resourceGroupName", newJString(resourceGroupName))
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "serverName", newJString(serverName))
  add(path_568236, "dataMaskingPolicyName", newJString(dataMaskingPolicyName))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  add(path_568236, "databaseName", newJString(databaseName))
  result = call_568235.call(path_568236, query_568237, nil, nil, nil)

var dataMaskingRulesListByDatabase* = Call_DataMaskingRulesListByDatabase_568225(
    name: "dataMaskingRulesListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/dataMaskingPolicies/{dataMaskingPolicyName}/rules",
    validator: validate_DataMaskingRulesListByDatabase_568226, base: "",
    url: url_DataMaskingRulesListByDatabase_568227, schemes: {Scheme.Https})
type
  Call_DataMaskingRulesCreateOrUpdate_568238 = ref object of OpenApiRestCall_567642
proc url_DataMaskingRulesCreateOrUpdate_568240(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "dataMaskingPolicyName" in path,
        "`dataMaskingPolicyName` is a required path parameter"
  assert "dataMaskingRuleName" in path,
        "`dataMaskingRuleName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/dataMaskingPolicies/"),
               (kind: VariableSegment, value: "dataMaskingPolicyName"),
               (kind: ConstantSegment, value: "/rules/"),
               (kind: VariableSegment, value: "dataMaskingRuleName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DataMaskingRulesCreateOrUpdate_568239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a database data masking rule.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   dataMaskingRuleName: JString (required)
  ##                      : The name of the data masking rule.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: JString (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `dataMaskingRuleName` field"
  var valid_568241 = path.getOrDefault("dataMaskingRuleName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "dataMaskingRuleName", valid_568241
  var valid_568242 = path.getOrDefault("resourceGroupName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "resourceGroupName", valid_568242
  var valid_568243 = path.getOrDefault("serverName")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "serverName", valid_568243
  var valid_568244 = path.getOrDefault("dataMaskingPolicyName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = newJString("Default"))
  if valid_568244 != nil:
    section.add "dataMaskingPolicyName", valid_568244
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  var valid_568246 = path.getOrDefault("databaseName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "databaseName", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a data masking rule.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_DataMaskingRulesCreateOrUpdate_568238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a database data masking rule.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_DataMaskingRulesCreateOrUpdate_568238;
          dataMaskingRuleName: string; resourceGroupName: string;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; parameters: JsonNode;
          dataMaskingPolicyName: string = "Default"): Recallable =
  ## dataMaskingRulesCreateOrUpdate
  ## Creates or updates a database data masking rule.
  ##   dataMaskingRuleName: string (required)
  ##                      : The name of the data masking rule.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   dataMaskingPolicyName: string (required)
  ##                        : The name of the database for which the data masking rule applies.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   parameters: JObject (required)
  ##             : The required parameters for creating or updating a data masking rule.
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  var body_568253 = newJObject()
  add(path_568251, "dataMaskingRuleName", newJString(dataMaskingRuleName))
  add(path_568251, "resourceGroupName", newJString(resourceGroupName))
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "serverName", newJString(serverName))
  add(path_568251, "dataMaskingPolicyName", newJString(dataMaskingPolicyName))
  add(path_568251, "subscriptionId", newJString(subscriptionId))
  add(path_568251, "databaseName", newJString(databaseName))
  if parameters != nil:
    body_568253 = parameters
  result = call_568250.call(path_568251, query_568252, nil, nil, body_568253)

var dataMaskingRulesCreateOrUpdate* = Call_DataMaskingRulesCreateOrUpdate_568238(
    name: "dataMaskingRulesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/dataMaskingPolicies/{dataMaskingPolicyName}/rules/{dataMaskingRuleName}",
    validator: validate_DataMaskingRulesCreateOrUpdate_568239, base: "",
    url: url_DataMaskingRulesCreateOrUpdate_568240, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

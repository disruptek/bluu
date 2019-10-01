
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "sql-sensitivityLabels"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SensitivityLabelsListCurrentByDatabase_567863 = ref object of OpenApiRestCall_567641
proc url_SensitivityLabelsListCurrentByDatabase_567865(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/currentSensitivityLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SensitivityLabelsListCurrentByDatabase_567864(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sensitivity labels of a given database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
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
  var valid_568041 = path.getOrDefault("subscriptionId")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "subscriptionId", valid_568041
  var valid_568042 = path.getOrDefault("databaseName")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "databaseName", valid_568042
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $filter: JString
  ##          : An OData filter expression that filters elements in the collection.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568043 = query.getOrDefault("api-version")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "api-version", valid_568043
  var valid_568044 = query.getOrDefault("$filter")
  valid_568044 = validateParameter(valid_568044, JString, required = false,
                                 default = nil)
  if valid_568044 != nil:
    section.add "$filter", valid_568044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568067: Call_SensitivityLabelsListCurrentByDatabase_567863;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the sensitivity labels of a given database
  ## 
  let valid = call_568067.validator(path, query, header, formData, body)
  let scheme = call_568067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568067.url(scheme.get, call_568067.host, call_568067.base,
                         call_568067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568067, url, valid)

proc call*(call_568138: Call_SensitivityLabelsListCurrentByDatabase_567863;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; Filter: string = ""): Recallable =
  ## sensitivityLabelsListCurrentByDatabase
  ## Gets the sensitivity labels of a given database
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   Filter: string
  ##         : An OData filter expression that filters elements in the collection.
  var path_568139 = newJObject()
  var query_568141 = newJObject()
  add(path_568139, "resourceGroupName", newJString(resourceGroupName))
  add(query_568141, "api-version", newJString(apiVersion))
  add(path_568139, "serverName", newJString(serverName))
  add(path_568139, "subscriptionId", newJString(subscriptionId))
  add(path_568139, "databaseName", newJString(databaseName))
  add(query_568141, "$filter", newJString(Filter))
  result = call_568138.call(path_568139, query_568141, nil, nil, nil)

var sensitivityLabelsListCurrentByDatabase* = Call_SensitivityLabelsListCurrentByDatabase_567863(
    name: "sensitivityLabelsListCurrentByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/currentSensitivityLabels",
    validator: validate_SensitivityLabelsListCurrentByDatabase_567864, base: "",
    url: url_SensitivityLabelsListCurrentByDatabase_567865,
    schemes: {Scheme.Https})
type
  Call_SensitivityLabelsListRecommendedByDatabase_568180 = ref object of OpenApiRestCall_567641
proc url_SensitivityLabelsListRecommendedByDatabase_568182(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/recommendedSensitivityLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SensitivityLabelsListRecommendedByDatabase_568181(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sensitivity labels of a given database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568183 = path.getOrDefault("resourceGroupName")
  valid_568183 = validateParameter(valid_568183, JString, required = true,
                                 default = nil)
  if valid_568183 != nil:
    section.add "resourceGroupName", valid_568183
  var valid_568184 = path.getOrDefault("serverName")
  valid_568184 = validateParameter(valid_568184, JString, required = true,
                                 default = nil)
  if valid_568184 != nil:
    section.add "serverName", valid_568184
  var valid_568185 = path.getOrDefault("subscriptionId")
  valid_568185 = validateParameter(valid_568185, JString, required = true,
                                 default = nil)
  if valid_568185 != nil:
    section.add "subscriptionId", valid_568185
  var valid_568186 = path.getOrDefault("databaseName")
  valid_568186 = validateParameter(valid_568186, JString, required = true,
                                 default = nil)
  if valid_568186 != nil:
    section.add "databaseName", valid_568186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $skipToken: JString
  ##   $filter: JString
  ##          : An OData filter expression that filters elements in the collection.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568187 = query.getOrDefault("api-version")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "api-version", valid_568187
  var valid_568188 = query.getOrDefault("$skipToken")
  valid_568188 = validateParameter(valid_568188, JString, required = false,
                                 default = nil)
  if valid_568188 != nil:
    section.add "$skipToken", valid_568188
  var valid_568189 = query.getOrDefault("$filter")
  valid_568189 = validateParameter(valid_568189, JString, required = false,
                                 default = nil)
  if valid_568189 != nil:
    section.add "$filter", valid_568189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568190: Call_SensitivityLabelsListRecommendedByDatabase_568180;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the sensitivity labels of a given database
  ## 
  let valid = call_568190.validator(path, query, header, formData, body)
  let scheme = call_568190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568190.url(scheme.get, call_568190.host, call_568190.base,
                         call_568190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568190, url, valid)

proc call*(call_568191: Call_SensitivityLabelsListRecommendedByDatabase_568180;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## sensitivityLabelsListRecommendedByDatabase
  ## Gets the sensitivity labels of a given database
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   SkipToken: string
  ##   Filter: string
  ##         : An OData filter expression that filters elements in the collection.
  var path_568192 = newJObject()
  var query_568193 = newJObject()
  add(path_568192, "resourceGroupName", newJString(resourceGroupName))
  add(query_568193, "api-version", newJString(apiVersion))
  add(path_568192, "serverName", newJString(serverName))
  add(path_568192, "subscriptionId", newJString(subscriptionId))
  add(path_568192, "databaseName", newJString(databaseName))
  add(query_568193, "$skipToken", newJString(SkipToken))
  add(query_568193, "$filter", newJString(Filter))
  result = call_568191.call(path_568192, query_568193, nil, nil, nil)

var sensitivityLabelsListRecommendedByDatabase* = Call_SensitivityLabelsListRecommendedByDatabase_568180(
    name: "sensitivityLabelsListRecommendedByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/recommendedSensitivityLabels",
    validator: validate_SensitivityLabelsListRecommendedByDatabase_568181,
    base: "", url: url_SensitivityLabelsListRecommendedByDatabase_568182,
    schemes: {Scheme.Https})
type
  Call_SensitivityLabelsCreateOrUpdate_568223 = ref object of OpenApiRestCall_567641
proc url_SensitivityLabelsCreateOrUpdate_568225(protocol: Scheme; host: string;
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
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  assert "columnName" in path, "`columnName` is a required path parameter"
  assert "sensitivityLabelSource" in path,
        "`sensitivityLabelSource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnName"),
               (kind: ConstantSegment, value: "/sensitivityLabels/"),
               (kind: VariableSegment, value: "sensitivityLabelSource")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SensitivityLabelsCreateOrUpdate_568224(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the sensitivity label of a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   sensitivityLabelSource: JString (required)
  ##                         : The source of the sensitivity label.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568226 = path.getOrDefault("resourceGroupName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "resourceGroupName", valid_568226
  var valid_568227 = path.getOrDefault("serverName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "serverName", valid_568227
  var valid_568228 = path.getOrDefault("subscriptionId")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "subscriptionId", valid_568228
  var valid_568229 = path.getOrDefault("columnName")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = nil)
  if valid_568229 != nil:
    section.add "columnName", valid_568229
  var valid_568230 = path.getOrDefault("schemaName")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "schemaName", valid_568230
  var valid_568231 = path.getOrDefault("tableName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "tableName", valid_568231
  var valid_568232 = path.getOrDefault("databaseName")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "databaseName", valid_568232
  var valid_568233 = path.getOrDefault("sensitivityLabelSource")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = newJString("current"))
  if valid_568233 != nil:
    section.add "sensitivityLabelSource", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The column sensitivity label resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_SensitivityLabelsCreateOrUpdate_568223;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the sensitivity label of a given column
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_SensitivityLabelsCreateOrUpdate_568223;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; columnName: string; schemaName: string;
          tableName: string; databaseName: string; parameters: JsonNode;
          sensitivityLabelSource: string = "current"): Recallable =
  ## sensitivityLabelsCreateOrUpdate
  ## Creates or updates the sensitivity label of a given column
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   sensitivityLabelSource: string (required)
  ##                         : The source of the sensitivity label.
  ##   parameters: JObject (required)
  ##             : The column sensitivity label resource.
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  var body_568240 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "serverName", newJString(serverName))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  add(path_568238, "columnName", newJString(columnName))
  add(path_568238, "schemaName", newJString(schemaName))
  add(path_568238, "tableName", newJString(tableName))
  add(path_568238, "databaseName", newJString(databaseName))
  add(path_568238, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  if parameters != nil:
    body_568240 = parameters
  result = call_568237.call(path_568238, query_568239, nil, nil, body_568240)

var sensitivityLabelsCreateOrUpdate* = Call_SensitivityLabelsCreateOrUpdate_568223(
    name: "sensitivityLabelsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}",
    validator: validate_SensitivityLabelsCreateOrUpdate_568224, base: "",
    url: url_SensitivityLabelsCreateOrUpdate_568225, schemes: {Scheme.Https})
type
  Call_SensitivityLabelsGet_568194 = ref object of OpenApiRestCall_567641
proc url_SensitivityLabelsGet_568196(protocol: Scheme; host: string; base: string;
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
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  assert "columnName" in path, "`columnName` is a required path parameter"
  assert "sensitivityLabelSource" in path,
        "`sensitivityLabelSource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnName"),
               (kind: ConstantSegment, value: "/sensitivityLabels/"),
               (kind: VariableSegment, value: "sensitivityLabelSource")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SensitivityLabelsGet_568195(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sensitivity label of a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   sensitivityLabelSource: JString (required)
  ##                         : The source of the sensitivity label.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568197 = path.getOrDefault("resourceGroupName")
  valid_568197 = validateParameter(valid_568197, JString, required = true,
                                 default = nil)
  if valid_568197 != nil:
    section.add "resourceGroupName", valid_568197
  var valid_568198 = path.getOrDefault("serverName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "serverName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  var valid_568200 = path.getOrDefault("columnName")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "columnName", valid_568200
  var valid_568201 = path.getOrDefault("schemaName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "schemaName", valid_568201
  var valid_568202 = path.getOrDefault("tableName")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "tableName", valid_568202
  var valid_568203 = path.getOrDefault("databaseName")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "databaseName", valid_568203
  var valid_568217 = path.getOrDefault("sensitivityLabelSource")
  valid_568217 = validateParameter(valid_568217, JString, required = true,
                                 default = newJString("current"))
  if valid_568217 != nil:
    section.add "sensitivityLabelSource", valid_568217
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
  if body != nil:
    result.add "body", body

proc call*(call_568219: Call_SensitivityLabelsGet_568194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the sensitivity label of a given column
  ## 
  let valid = call_568219.validator(path, query, header, formData, body)
  let scheme = call_568219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568219.url(scheme.get, call_568219.host, call_568219.base,
                         call_568219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568219, url, valid)

proc call*(call_568220: Call_SensitivityLabelsGet_568194;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; columnName: string; schemaName: string;
          tableName: string; databaseName: string;
          sensitivityLabelSource: string = "current"): Recallable =
  ## sensitivityLabelsGet
  ## Gets the sensitivity label of a given column
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   sensitivityLabelSource: string (required)
  ##                         : The source of the sensitivity label.
  var path_568221 = newJObject()
  var query_568222 = newJObject()
  add(path_568221, "resourceGroupName", newJString(resourceGroupName))
  add(query_568222, "api-version", newJString(apiVersion))
  add(path_568221, "serverName", newJString(serverName))
  add(path_568221, "subscriptionId", newJString(subscriptionId))
  add(path_568221, "columnName", newJString(columnName))
  add(path_568221, "schemaName", newJString(schemaName))
  add(path_568221, "tableName", newJString(tableName))
  add(path_568221, "databaseName", newJString(databaseName))
  add(path_568221, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  result = call_568220.call(path_568221, query_568222, nil, nil, nil)

var sensitivityLabelsGet* = Call_SensitivityLabelsGet_568194(
    name: "sensitivityLabelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}",
    validator: validate_SensitivityLabelsGet_568195, base: "",
    url: url_SensitivityLabelsGet_568196, schemes: {Scheme.Https})
type
  Call_SensitivityLabelsDelete_568241 = ref object of OpenApiRestCall_567641
proc url_SensitivityLabelsDelete_568243(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "schemaName" in path, "`schemaName` is a required path parameter"
  assert "tableName" in path, "`tableName` is a required path parameter"
  assert "columnName" in path, "`columnName` is a required path parameter"
  assert "sensitivityLabelSource" in path,
        "`sensitivityLabelSource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnName"),
               (kind: ConstantSegment, value: "/sensitivityLabels/"),
               (kind: VariableSegment, value: "sensitivityLabelSource")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SensitivityLabelsDelete_568242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the sensitivity label of a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   sensitivityLabelSource: JString (required)
  ##                         : The source of the sensitivity label.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568244 = path.getOrDefault("resourceGroupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceGroupName", valid_568244
  var valid_568245 = path.getOrDefault("serverName")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "serverName", valid_568245
  var valid_568246 = path.getOrDefault("subscriptionId")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "subscriptionId", valid_568246
  var valid_568247 = path.getOrDefault("columnName")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "columnName", valid_568247
  var valid_568248 = path.getOrDefault("schemaName")
  valid_568248 = validateParameter(valid_568248, JString, required = true,
                                 default = nil)
  if valid_568248 != nil:
    section.add "schemaName", valid_568248
  var valid_568249 = path.getOrDefault("tableName")
  valid_568249 = validateParameter(valid_568249, JString, required = true,
                                 default = nil)
  if valid_568249 != nil:
    section.add "tableName", valid_568249
  var valid_568250 = path.getOrDefault("databaseName")
  valid_568250 = validateParameter(valid_568250, JString, required = true,
                                 default = nil)
  if valid_568250 != nil:
    section.add "databaseName", valid_568250
  var valid_568251 = path.getOrDefault("sensitivityLabelSource")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = newJString("current"))
  if valid_568251 != nil:
    section.add "sensitivityLabelSource", valid_568251
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "api-version", valid_568252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568253: Call_SensitivityLabelsDelete_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the sensitivity label of a given column
  ## 
  let valid = call_568253.validator(path, query, header, formData, body)
  let scheme = call_568253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568253.url(scheme.get, call_568253.host, call_568253.base,
                         call_568253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568253, url, valid)

proc call*(call_568254: Call_SensitivityLabelsDelete_568241;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; columnName: string; schemaName: string;
          tableName: string; databaseName: string;
          sensitivityLabelSource: string = "current"): Recallable =
  ## sensitivityLabelsDelete
  ## Deletes the sensitivity label of a given column
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   sensitivityLabelSource: string (required)
  ##                         : The source of the sensitivity label.
  var path_568255 = newJObject()
  var query_568256 = newJObject()
  add(path_568255, "resourceGroupName", newJString(resourceGroupName))
  add(query_568256, "api-version", newJString(apiVersion))
  add(path_568255, "serverName", newJString(serverName))
  add(path_568255, "subscriptionId", newJString(subscriptionId))
  add(path_568255, "columnName", newJString(columnName))
  add(path_568255, "schemaName", newJString(schemaName))
  add(path_568255, "tableName", newJString(tableName))
  add(path_568255, "databaseName", newJString(databaseName))
  add(path_568255, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  result = call_568254.call(path_568255, query_568256, nil, nil, nil)

var sensitivityLabelsDelete* = Call_SensitivityLabelsDelete_568241(
    name: "sensitivityLabelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}",
    validator: validate_SensitivityLabelsDelete_568242, base: "",
    url: url_SensitivityLabelsDelete_568243, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

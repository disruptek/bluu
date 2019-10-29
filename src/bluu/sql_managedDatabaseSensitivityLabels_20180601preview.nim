
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2018-06-01-preview
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

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
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
  macServiceName = "sql-managedDatabaseSensitivityLabels"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563761 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563763(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/currentSensitivityLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563762(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the sensitivity labels of a given database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563939 = path.getOrDefault("subscriptionId")
  valid_563939 = validateParameter(valid_563939, JString, required = true,
                                 default = nil)
  if valid_563939 != nil:
    section.add "subscriptionId", valid_563939
  var valid_563940 = path.getOrDefault("databaseName")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "databaseName", valid_563940
  var valid_563941 = path.getOrDefault("resourceGroupName")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "resourceGroupName", valid_563941
  var valid_563942 = path.getOrDefault("managedInstanceName")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "managedInstanceName", valid_563942
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $filter: JString
  ##          : An OData filter expression that filters elements in the collection.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563943 = query.getOrDefault("api-version")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "api-version", valid_563943
  var valid_563944 = query.getOrDefault("$filter")
  valid_563944 = validateParameter(valid_563944, JString, required = false,
                                 default = nil)
  if valid_563944 != nil:
    section.add "$filter", valid_563944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563967: Call_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the sensitivity labels of a given database
  ## 
  let valid = call_563967.validator(path, query, header, formData, body)
  let scheme = call_563967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563967.url(scheme.get, call_563967.host, call_563967.base,
                         call_563967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563967, url, valid)

proc call*(call_564038: Call_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563761;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; managedInstanceName: string;
          Filter: string = ""): Recallable =
  ## managedDatabaseSensitivityLabelsListCurrentByDatabase
  ## Gets the sensitivity labels of a given database
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Filter: string
  ##         : An OData filter expression that filters elements in the collection.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564039 = newJObject()
  var query_564041 = newJObject()
  add(query_564041, "api-version", newJString(apiVersion))
  add(path_564039, "subscriptionId", newJString(subscriptionId))
  add(path_564039, "databaseName", newJString(databaseName))
  add(path_564039, "resourceGroupName", newJString(resourceGroupName))
  add(query_564041, "$filter", newJString(Filter))
  add(path_564039, "managedInstanceName", newJString(managedInstanceName))
  result = call_564038.call(path_564039, query_564041, nil, nil, nil)

var managedDatabaseSensitivityLabelsListCurrentByDatabase* = Call_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563761(
    name: "managedDatabaseSensitivityLabelsListCurrentByDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/currentSensitivityLabels",
    validator: validate_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563762,
    base: "", url: url_ManagedDatabaseSensitivityLabelsListCurrentByDatabase_563763,
    schemes: {Scheme.Https})
type
  Call_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564080 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564082(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/recommendedSensitivityLabels")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564081(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the sensitivity labels of a given database
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564083 = path.getOrDefault("subscriptionId")
  valid_564083 = validateParameter(valid_564083, JString, required = true,
                                 default = nil)
  if valid_564083 != nil:
    section.add "subscriptionId", valid_564083
  var valid_564084 = path.getOrDefault("databaseName")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "databaseName", valid_564084
  var valid_564085 = path.getOrDefault("resourceGroupName")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "resourceGroupName", valid_564085
  var valid_564086 = path.getOrDefault("managedInstanceName")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "managedInstanceName", valid_564086
  result.add "path", section
  ## parameters in `query` object:
  ##   includeDisabledRecommendations: JBool
  ##                                 : Specifies whether to include disabled recommendations or not.
  ##   $skipToken: JString
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   $filter: JString
  ##          : An OData filter expression that filters elements in the collection.
  section = newJObject()
  var valid_564087 = query.getOrDefault("includeDisabledRecommendations")
  valid_564087 = validateParameter(valid_564087, JBool, required = false, default = nil)
  if valid_564087 != nil:
    section.add "includeDisabledRecommendations", valid_564087
  var valid_564088 = query.getOrDefault("$skipToken")
  valid_564088 = validateParameter(valid_564088, JString, required = false,
                                 default = nil)
  if valid_564088 != nil:
    section.add "$skipToken", valid_564088
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564089 = query.getOrDefault("api-version")
  valid_564089 = validateParameter(valid_564089, JString, required = true,
                                 default = nil)
  if valid_564089 != nil:
    section.add "api-version", valid_564089
  var valid_564090 = query.getOrDefault("$filter")
  valid_564090 = validateParameter(valid_564090, JString, required = false,
                                 default = nil)
  if valid_564090 != nil:
    section.add "$filter", valid_564090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564091: Call_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564080;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the sensitivity labels of a given database
  ## 
  let valid = call_564091.validator(path, query, header, formData, body)
  let scheme = call_564091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564091.url(scheme.get, call_564091.host, call_564091.base,
                         call_564091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564091, url, valid)

proc call*(call_564092: Call_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564080;
          apiVersion: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; managedInstanceName: string;
          includeDisabledRecommendations: bool = false; SkipToken: string = "";
          Filter: string = ""): Recallable =
  ## managedDatabaseSensitivityLabelsListRecommendedByDatabase
  ## Gets the sensitivity labels of a given database
  ##   includeDisabledRecommendations: bool
  ##                                 : Specifies whether to include disabled recommendations or not.
  ##   SkipToken: string
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   Filter: string
  ##         : An OData filter expression that filters elements in the collection.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564093 = newJObject()
  var query_564094 = newJObject()
  add(query_564094, "includeDisabledRecommendations",
      newJBool(includeDisabledRecommendations))
  add(query_564094, "$skipToken", newJString(SkipToken))
  add(query_564094, "api-version", newJString(apiVersion))
  add(path_564093, "subscriptionId", newJString(subscriptionId))
  add(path_564093, "databaseName", newJString(databaseName))
  add(path_564093, "resourceGroupName", newJString(resourceGroupName))
  add(query_564094, "$filter", newJString(Filter))
  add(path_564093, "managedInstanceName", newJString(managedInstanceName))
  result = call_564092.call(path_564093, query_564094, nil, nil, nil)

var managedDatabaseSensitivityLabelsListRecommendedByDatabase* = Call_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564080(
    name: "managedDatabaseSensitivityLabelsListRecommendedByDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/recommendedSensitivityLabels", validator: validate_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564081,
    base: "", url: url_ManagedDatabaseSensitivityLabelsListRecommendedByDatabase_564082,
    schemes: {Scheme.Https})
type
  Call_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564124 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564126(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
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

proc validate_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564125(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates the sensitivity label of a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sensitivityLabelSource: JString (required)
  ##                         : The source of the sensitivity label.
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sensitivityLabelSource` field"
  var valid_564127 = path.getOrDefault("sensitivityLabelSource")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = newJString("current"))
  if valid_564127 != nil:
    section.add "sensitivityLabelSource", valid_564127
  var valid_564128 = path.getOrDefault("columnName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "columnName", valid_564128
  var valid_564129 = path.getOrDefault("subscriptionId")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "subscriptionId", valid_564129
  var valid_564130 = path.getOrDefault("databaseName")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "databaseName", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroupName", valid_564131
  var valid_564132 = path.getOrDefault("schemaName")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "schemaName", valid_564132
  var valid_564133 = path.getOrDefault("tableName")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = nil)
  if valid_564133 != nil:
    section.add "tableName", valid_564133
  var valid_564134 = path.getOrDefault("managedInstanceName")
  valid_564134 = validateParameter(valid_564134, JString, required = true,
                                 default = nil)
  if valid_564134 != nil:
    section.add "managedInstanceName", valid_564134
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564135 = query.getOrDefault("api-version")
  valid_564135 = validateParameter(valid_564135, JString, required = true,
                                 default = nil)
  if valid_564135 != nil:
    section.add "api-version", valid_564135
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

proc call*(call_564137: Call_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates the sensitivity label of a given column
  ## 
  let valid = call_564137.validator(path, query, header, formData, body)
  let scheme = call_564137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564137.url(scheme.get, call_564137.host, call_564137.base,
                         call_564137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564137, url, valid)

proc call*(call_564138: Call_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564124;
          apiVersion: string; columnName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; schemaName: string;
          tableName: string; managedInstanceName: string; parameters: JsonNode;
          sensitivityLabelSource: string = "current"): Recallable =
  ## managedDatabaseSensitivityLabelsCreateOrUpdate
  ## Creates or updates the sensitivity label of a given column
  ##   sensitivityLabelSource: string (required)
  ##                         : The source of the sensitivity label.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  ##   parameters: JObject (required)
  ##             : The column sensitivity label resource.
  var path_564139 = newJObject()
  var query_564140 = newJObject()
  var body_564141 = newJObject()
  add(path_564139, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  add(query_564140, "api-version", newJString(apiVersion))
  add(path_564139, "columnName", newJString(columnName))
  add(path_564139, "subscriptionId", newJString(subscriptionId))
  add(path_564139, "databaseName", newJString(databaseName))
  add(path_564139, "resourceGroupName", newJString(resourceGroupName))
  add(path_564139, "schemaName", newJString(schemaName))
  add(path_564139, "tableName", newJString(tableName))
  add(path_564139, "managedInstanceName", newJString(managedInstanceName))
  if parameters != nil:
    body_564141 = parameters
  result = call_564138.call(path_564139, query_564140, nil, nil, body_564141)

var managedDatabaseSensitivityLabelsCreateOrUpdate* = Call_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564124(
    name: "managedDatabaseSensitivityLabelsCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}",
    validator: validate_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564125,
    base: "", url: url_ManagedDatabaseSensitivityLabelsCreateOrUpdate_564126,
    schemes: {Scheme.Https})
type
  Call_ManagedDatabaseSensitivityLabelsGet_564095 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsGet_564097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
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

proc validate_ManagedDatabaseSensitivityLabelsGet_564096(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the sensitivity label of a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sensitivityLabelSource: JString (required)
  ##                         : The source of the sensitivity label.
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sensitivityLabelSource` field"
  var valid_564111 = path.getOrDefault("sensitivityLabelSource")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = newJString("current"))
  if valid_564111 != nil:
    section.add "sensitivityLabelSource", valid_564111
  var valid_564112 = path.getOrDefault("columnName")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "columnName", valid_564112
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("databaseName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "databaseName", valid_564114
  var valid_564115 = path.getOrDefault("resourceGroupName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "resourceGroupName", valid_564115
  var valid_564116 = path.getOrDefault("schemaName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "schemaName", valid_564116
  var valid_564117 = path.getOrDefault("tableName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "tableName", valid_564117
  var valid_564118 = path.getOrDefault("managedInstanceName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "managedInstanceName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_ManagedDatabaseSensitivityLabelsGet_564095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the sensitivity label of a given column
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_ManagedDatabaseSensitivityLabelsGet_564095;
          apiVersion: string; columnName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; schemaName: string;
          tableName: string; managedInstanceName: string;
          sensitivityLabelSource: string = "current"): Recallable =
  ## managedDatabaseSensitivityLabelsGet
  ## Gets the sensitivity label of a given column
  ##   sensitivityLabelSource: string (required)
  ##                         : The source of the sensitivity label.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(path_564122, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "columnName", newJString(columnName))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "databaseName", newJString(databaseName))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  add(path_564122, "schemaName", newJString(schemaName))
  add(path_564122, "tableName", newJString(tableName))
  add(path_564122, "managedInstanceName", newJString(managedInstanceName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var managedDatabaseSensitivityLabelsGet* = Call_ManagedDatabaseSensitivityLabelsGet_564095(
    name: "managedDatabaseSensitivityLabelsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}",
    validator: validate_ManagedDatabaseSensitivityLabelsGet_564096, base: "",
    url: url_ManagedDatabaseSensitivityLabelsGet_564097, schemes: {Scheme.Https})
type
  Call_ManagedDatabaseSensitivityLabelsDelete_564142 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsDelete_564144(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
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

proc validate_ManagedDatabaseSensitivityLabelsDelete_564143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the sensitivity label of a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sensitivityLabelSource: JString (required)
  ##                         : The source of the sensitivity label.
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sensitivityLabelSource` field"
  var valid_564145 = path.getOrDefault("sensitivityLabelSource")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = newJString("current"))
  if valid_564145 != nil:
    section.add "sensitivityLabelSource", valid_564145
  var valid_564146 = path.getOrDefault("columnName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "columnName", valid_564146
  var valid_564147 = path.getOrDefault("subscriptionId")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "subscriptionId", valid_564147
  var valid_564148 = path.getOrDefault("databaseName")
  valid_564148 = validateParameter(valid_564148, JString, required = true,
                                 default = nil)
  if valid_564148 != nil:
    section.add "databaseName", valid_564148
  var valid_564149 = path.getOrDefault("resourceGroupName")
  valid_564149 = validateParameter(valid_564149, JString, required = true,
                                 default = nil)
  if valid_564149 != nil:
    section.add "resourceGroupName", valid_564149
  var valid_564150 = path.getOrDefault("schemaName")
  valid_564150 = validateParameter(valid_564150, JString, required = true,
                                 default = nil)
  if valid_564150 != nil:
    section.add "schemaName", valid_564150
  var valid_564151 = path.getOrDefault("tableName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "tableName", valid_564151
  var valid_564152 = path.getOrDefault("managedInstanceName")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "managedInstanceName", valid_564152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564153 = query.getOrDefault("api-version")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "api-version", valid_564153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_ManagedDatabaseSensitivityLabelsDelete_564142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the sensitivity label of a given column
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_ManagedDatabaseSensitivityLabelsDelete_564142;
          apiVersion: string; columnName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; schemaName: string;
          tableName: string; managedInstanceName: string;
          sensitivityLabelSource: string = "current"): Recallable =
  ## managedDatabaseSensitivityLabelsDelete
  ## Deletes the sensitivity label of a given column
  ##   sensitivityLabelSource: string (required)
  ##                         : The source of the sensitivity label.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564156 = newJObject()
  var query_564157 = newJObject()
  add(path_564156, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  add(query_564157, "api-version", newJString(apiVersion))
  add(path_564156, "columnName", newJString(columnName))
  add(path_564156, "subscriptionId", newJString(subscriptionId))
  add(path_564156, "databaseName", newJString(databaseName))
  add(path_564156, "resourceGroupName", newJString(resourceGroupName))
  add(path_564156, "schemaName", newJString(schemaName))
  add(path_564156, "tableName", newJString(tableName))
  add(path_564156, "managedInstanceName", newJString(managedInstanceName))
  result = call_564155.call(path_564156, query_564157, nil, nil, nil)

var managedDatabaseSensitivityLabelsDelete* = Call_ManagedDatabaseSensitivityLabelsDelete_564142(
    name: "managedDatabaseSensitivityLabelsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}",
    validator: validate_ManagedDatabaseSensitivityLabelsDelete_564143, base: "",
    url: url_ManagedDatabaseSensitivityLabelsDelete_564144,
    schemes: {Scheme.Https})
type
  Call_ManagedDatabaseSensitivityLabelsDisableRecommendation_564158 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsDisableRecommendation_564160(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnName"),
               (kind: ConstantSegment, value: "/sensitivityLabels/"),
               (kind: VariableSegment, value: "sensitivityLabelSource"),
               (kind: ConstantSegment, value: "/disable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabaseSensitivityLabelsDisableRecommendation_564159(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Disables sensitivity recommendations on a given column
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sensitivityLabelSource: JString (required)
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sensitivityLabelSource` field"
  var valid_564161 = path.getOrDefault("sensitivityLabelSource")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("recommended"))
  if valid_564161 != nil:
    section.add "sensitivityLabelSource", valid_564161
  var valid_564162 = path.getOrDefault("columnName")
  valid_564162 = validateParameter(valid_564162, JString, required = true,
                                 default = nil)
  if valid_564162 != nil:
    section.add "columnName", valid_564162
  var valid_564163 = path.getOrDefault("subscriptionId")
  valid_564163 = validateParameter(valid_564163, JString, required = true,
                                 default = nil)
  if valid_564163 != nil:
    section.add "subscriptionId", valid_564163
  var valid_564164 = path.getOrDefault("databaseName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "databaseName", valid_564164
  var valid_564165 = path.getOrDefault("resourceGroupName")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "resourceGroupName", valid_564165
  var valid_564166 = path.getOrDefault("schemaName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "schemaName", valid_564166
  var valid_564167 = path.getOrDefault("tableName")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "tableName", valid_564167
  var valid_564168 = path.getOrDefault("managedInstanceName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "managedInstanceName", valid_564168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_ManagedDatabaseSensitivityLabelsDisableRecommendation_564158;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disables sensitivity recommendations on a given column
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_ManagedDatabaseSensitivityLabelsDisableRecommendation_564158;
          apiVersion: string; columnName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; schemaName: string;
          tableName: string; managedInstanceName: string;
          sensitivityLabelSource: string = "recommended"): Recallable =
  ## managedDatabaseSensitivityLabelsDisableRecommendation
  ## Disables sensitivity recommendations on a given column
  ##   sensitivityLabelSource: string (required)
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(path_564172, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  add(query_564173, "api-version", newJString(apiVersion))
  add(path_564172, "columnName", newJString(columnName))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(path_564172, "databaseName", newJString(databaseName))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  add(path_564172, "schemaName", newJString(schemaName))
  add(path_564172, "tableName", newJString(tableName))
  add(path_564172, "managedInstanceName", newJString(managedInstanceName))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var managedDatabaseSensitivityLabelsDisableRecommendation* = Call_ManagedDatabaseSensitivityLabelsDisableRecommendation_564158(
    name: "managedDatabaseSensitivityLabelsDisableRecommendation",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}/disable",
    validator: validate_ManagedDatabaseSensitivityLabelsDisableRecommendation_564159,
    base: "", url: url_ManagedDatabaseSensitivityLabelsDisableRecommendation_564160,
    schemes: {Scheme.Https})
type
  Call_ManagedDatabaseSensitivityLabelsEnableRecommendation_564174 = ref object of OpenApiRestCall_563539
proc url_ManagedDatabaseSensitivityLabelsEnableRecommendation_564176(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedInstanceName" in path,
        "`managedInstanceName` is a required path parameter"
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
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/managedInstances/"),
               (kind: VariableSegment, value: "managedInstanceName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaName"),
               (kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableName"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnName"),
               (kind: ConstantSegment, value: "/sensitivityLabels/"),
               (kind: VariableSegment, value: "sensitivityLabelSource"),
               (kind: ConstantSegment, value: "/enable")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedDatabaseSensitivityLabelsEnableRecommendation_564175(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enables sensitivity recommendations on a given column (recommendations are enabled by default on all columns)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   sensitivityLabelSource: JString (required)
  ##   columnName: JString (required)
  ##             : The name of the column.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: JString (required)
  ##             : The name of the schema.
  ##   tableName: JString (required)
  ##            : The name of the table.
  ##   managedInstanceName: JString (required)
  ##                      : The name of the managed instance.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `sensitivityLabelSource` field"
  var valid_564177 = path.getOrDefault("sensitivityLabelSource")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = newJString("recommended"))
  if valid_564177 != nil:
    section.add "sensitivityLabelSource", valid_564177
  var valid_564178 = path.getOrDefault("columnName")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "columnName", valid_564178
  var valid_564179 = path.getOrDefault("subscriptionId")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "subscriptionId", valid_564179
  var valid_564180 = path.getOrDefault("databaseName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "databaseName", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  var valid_564182 = path.getOrDefault("schemaName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "schemaName", valid_564182
  var valid_564183 = path.getOrDefault("tableName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "tableName", valid_564183
  var valid_564184 = path.getOrDefault("managedInstanceName")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "managedInstanceName", valid_564184
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564185 = query.getOrDefault("api-version")
  valid_564185 = validateParameter(valid_564185, JString, required = true,
                                 default = nil)
  if valid_564185 != nil:
    section.add "api-version", valid_564185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564186: Call_ManagedDatabaseSensitivityLabelsEnableRecommendation_564174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enables sensitivity recommendations on a given column (recommendations are enabled by default on all columns)
  ## 
  let valid = call_564186.validator(path, query, header, formData, body)
  let scheme = call_564186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564186.url(scheme.get, call_564186.host, call_564186.base,
                         call_564186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564186, url, valid)

proc call*(call_564187: Call_ManagedDatabaseSensitivityLabelsEnableRecommendation_564174;
          apiVersion: string; columnName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; schemaName: string;
          tableName: string; managedInstanceName: string;
          sensitivityLabelSource: string = "recommended"): Recallable =
  ## managedDatabaseSensitivityLabelsEnableRecommendation
  ## Enables sensitivity recommendations on a given column (recommendations are enabled by default on all columns)
  ##   sensitivityLabelSource: string (required)
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   columnName: string (required)
  ##             : The name of the column.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   schemaName: string (required)
  ##             : The name of the schema.
  ##   tableName: string (required)
  ##            : The name of the table.
  ##   managedInstanceName: string (required)
  ##                      : The name of the managed instance.
  var path_564188 = newJObject()
  var query_564189 = newJObject()
  add(path_564188, "sensitivityLabelSource", newJString(sensitivityLabelSource))
  add(query_564189, "api-version", newJString(apiVersion))
  add(path_564188, "columnName", newJString(columnName))
  add(path_564188, "subscriptionId", newJString(subscriptionId))
  add(path_564188, "databaseName", newJString(databaseName))
  add(path_564188, "resourceGroupName", newJString(resourceGroupName))
  add(path_564188, "schemaName", newJString(schemaName))
  add(path_564188, "tableName", newJString(tableName))
  add(path_564188, "managedInstanceName", newJString(managedInstanceName))
  result = call_564187.call(path_564188, query_564189, nil, nil, nil)

var managedDatabaseSensitivityLabelsEnableRecommendation* = Call_ManagedDatabaseSensitivityLabelsEnableRecommendation_564174(
    name: "managedDatabaseSensitivityLabelsEnableRecommendation",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/managedInstances/{managedInstanceName}/databases/{databaseName}/schemas/{schemaName}/tables/{tableName}/columns/{columnName}/sensitivityLabels/{sensitivityLabelSource}/enable",
    validator: validate_ManagedDatabaseSensitivityLabelsEnableRecommendation_564175,
    base: "", url: url_ManagedDatabaseSensitivityLabelsEnableRecommendation_564176,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)

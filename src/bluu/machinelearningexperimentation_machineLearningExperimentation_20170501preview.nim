
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ML Team Account Management Client
## version: 2017-05-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## These APIs allow end users to operate on Azure Machine Learning Team Account resources. They support CRUD operations for Azure Machine Learning Team Accounts.
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
  macServiceName = "machinelearningexperimentation-machineLearningExperimentation"
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
  ## Lists all of the available Azure Machine Learning Team Accounts REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
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
  ## Lists all of the available Azure Machine Learning Team Accounts REST API operations.
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
  ## Lists all of the available Azure Machine Learning Team Accounts REST API operations.
  ##   apiVersion: string (required)
  ##             : The client API version.
  var query_593903 = newJObject()
  add(query_593903, "api-version", newJString(apiVersion))
  result = call_593902.call(nil, query_593903, nil, nil, nil)

var operationsList* = Call_OperationsList_593647(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.MachineLearningExperimentation/operations",
    validator: validate_OperationsList_593648, base: "", url: url_OperationsList_593649,
    schemes: {Scheme.Https})
type
  Call_AccountsList_593943 = ref object of OpenApiRestCall_593425
proc url_AccountsList_593945(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsList_593944(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning team accounts under the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593960 = path.getOrDefault("subscriptionId")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "subscriptionId", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_AccountsList_593943; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning team accounts under the specified subscription.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_AccountsList_593943; apiVersion: string;
          subscriptionId: string): Recallable =
  ## accountsList
  ## Lists all the available machine learning team accounts under the specified subscription.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var accountsList* = Call_AccountsList_593943(name: "accountsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MachineLearningExperimentation/accounts",
    validator: validate_AccountsList_593944, base: "", url: url_AccountsList_593945,
    schemes: {Scheme.Https})
type
  Call_AccountsListByResourceGroup_593966 = ref object of OpenApiRestCall_593425
proc url_AccountsListByResourceGroup_593968(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsListByResourceGroup_593967(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning team accounts under the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593969 = path.getOrDefault("resourceGroupName")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "resourceGroupName", valid_593969
  var valid_593970 = path.getOrDefault("subscriptionId")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "subscriptionId", valid_593970
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593971 = query.getOrDefault("api-version")
  valid_593971 = validateParameter(valid_593971, JString, required = true,
                                 default = nil)
  if valid_593971 != nil:
    section.add "api-version", valid_593971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593972: Call_AccountsListByResourceGroup_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning team accounts under the specified resource group.
  ## 
  let valid = call_593972.validator(path, query, header, formData, body)
  let scheme = call_593972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593972.url(scheme.get, call_593972.host, call_593972.base,
                         call_593972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593972, url, valid)

proc call*(call_593973: Call_AccountsListByResourceGroup_593966;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## accountsListByResourceGroup
  ## Lists all the available machine learning team accounts under the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  var path_593974 = newJObject()
  var query_593975 = newJObject()
  add(path_593974, "resourceGroupName", newJString(resourceGroupName))
  add(query_593975, "api-version", newJString(apiVersion))
  add(path_593974, "subscriptionId", newJString(subscriptionId))
  result = call_593973.call(path_593974, query_593975, nil, nil, nil)

var accountsListByResourceGroup* = Call_AccountsListByResourceGroup_593966(
    name: "accountsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts",
    validator: validate_AccountsListByResourceGroup_593967, base: "",
    url: url_AccountsListByResourceGroup_593968, schemes: {Scheme.Https})
type
  Call_AccountsCreateOrUpdate_593987 = ref object of OpenApiRestCall_593425
proc url_AccountsCreateOrUpdate_593989(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsCreateOrUpdate_593988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a team account with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593990 = path.getOrDefault("resourceGroupName")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "resourceGroupName", valid_593990
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("accountName")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "accountName", valid_593992
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593993 = query.getOrDefault("api-version")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "api-version", valid_593993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning team account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_AccountsCreateOrUpdate_593987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a team account with the specified parameters.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_AccountsCreateOrUpdate_593987;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; accountName: string): Recallable =
  ## accountsCreateOrUpdate
  ## Creates or updates a team account with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning team account.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  var body_593999 = newJObject()
  add(path_593997, "resourceGroupName", newJString(resourceGroupName))
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593999 = parameters
  add(path_593997, "accountName", newJString(accountName))
  result = call_593996.call(path_593997, query_593998, nil, nil, body_593999)

var accountsCreateOrUpdate* = Call_AccountsCreateOrUpdate_593987(
    name: "accountsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}",
    validator: validate_AccountsCreateOrUpdate_593988, base: "",
    url: url_AccountsCreateOrUpdate_593989, schemes: {Scheme.Https})
type
  Call_AccountsGet_593976 = ref object of OpenApiRestCall_593425
proc url_AccountsGet_593978(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsGet_593977(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning team account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593979 = path.getOrDefault("resourceGroupName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "resourceGroupName", valid_593979
  var valid_593980 = path.getOrDefault("subscriptionId")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "subscriptionId", valid_593980
  var valid_593981 = path.getOrDefault("accountName")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "accountName", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593982 = query.getOrDefault("api-version")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "api-version", valid_593982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593983: Call_AccountsGet_593976; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning team account.
  ## 
  let valid = call_593983.validator(path, query, header, formData, body)
  let scheme = call_593983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593983.url(scheme.get, call_593983.host, call_593983.base,
                         call_593983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593983, url, valid)

proc call*(call_593984: Call_AccountsGet_593976; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsGet
  ## Gets the properties of the specified machine learning team account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_593985 = newJObject()
  var query_593986 = newJObject()
  add(path_593985, "resourceGroupName", newJString(resourceGroupName))
  add(query_593986, "api-version", newJString(apiVersion))
  add(path_593985, "subscriptionId", newJString(subscriptionId))
  add(path_593985, "accountName", newJString(accountName))
  result = call_593984.call(path_593985, query_593986, nil, nil, nil)

var accountsGet* = Call_AccountsGet_593976(name: "accountsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}",
                                        validator: validate_AccountsGet_593977,
                                        base: "", url: url_AccountsGet_593978,
                                        schemes: {Scheme.Https})
type
  Call_AccountsUpdate_594011 = ref object of OpenApiRestCall_593425
proc url_AccountsUpdate_594013(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsUpdate_594012(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a machine learning team account with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  var valid_594033 = path.getOrDefault("accountName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "accountName", valid_594033
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning team account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_AccountsUpdate_594011; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning team account with the specified parameters.
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_AccountsUpdate_594011; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          accountName: string): Recallable =
  ## accountsUpdate
  ## Updates a machine learning team account with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning team account.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  var body_594040 = newJObject()
  add(path_594038, "resourceGroupName", newJString(resourceGroupName))
  add(query_594039, "api-version", newJString(apiVersion))
  add(path_594038, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594040 = parameters
  add(path_594038, "accountName", newJString(accountName))
  result = call_594037.call(path_594038, query_594039, nil, nil, body_594040)

var accountsUpdate* = Call_AccountsUpdate_594011(name: "accountsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}",
    validator: validate_AccountsUpdate_594012, base: "", url: url_AccountsUpdate_594013,
    schemes: {Scheme.Https})
type
  Call_AccountsDelete_594000 = ref object of OpenApiRestCall_593425
proc url_AccountsDelete_594002(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AccountsDelete_594001(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a machine learning team account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594003 = path.getOrDefault("resourceGroupName")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "resourceGroupName", valid_594003
  var valid_594004 = path.getOrDefault("subscriptionId")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "subscriptionId", valid_594004
  var valid_594005 = path.getOrDefault("accountName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "accountName", valid_594005
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594006 = query.getOrDefault("api-version")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "api-version", valid_594006
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594007: Call_AccountsDelete_594000; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning team account.
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_AccountsDelete_594000; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; accountName: string): Recallable =
  ## accountsDelete
  ## Deletes a machine learning team account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594009 = newJObject()
  var query_594010 = newJObject()
  add(path_594009, "resourceGroupName", newJString(resourceGroupName))
  add(query_594010, "api-version", newJString(apiVersion))
  add(path_594009, "subscriptionId", newJString(subscriptionId))
  add(path_594009, "accountName", newJString(accountName))
  result = call_594008.call(path_594009, query_594010, nil, nil, nil)

var accountsDelete* = Call_AccountsDelete_594000(name: "accountsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}",
    validator: validate_AccountsDelete_594001, base: "", url: url_AccountsDelete_594002,
    schemes: {Scheme.Https})
type
  Call_WorkspacesListByAccounts_594041 = ref object of OpenApiRestCall_593425
proc url_WorkspacesListByAccounts_594043(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesListByAccounts_594042(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning workspaces under the specified team account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
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
  var valid_594046 = path.getOrDefault("accountName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "accountName", valid_594046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594047 = query.getOrDefault("api-version")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "api-version", valid_594047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594048: Call_WorkspacesListByAccounts_594041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning workspaces under the specified team account.
  ## 
  let valid = call_594048.validator(path, query, header, formData, body)
  let scheme = call_594048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594048.url(scheme.get, call_594048.host, call_594048.base,
                         call_594048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594048, url, valid)

proc call*(call_594049: Call_WorkspacesListByAccounts_594041;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          accountName: string): Recallable =
  ## workspacesListByAccounts
  ## Lists all the available machine learning workspaces under the specified team account.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594050 = newJObject()
  var query_594051 = newJObject()
  add(path_594050, "resourceGroupName", newJString(resourceGroupName))
  add(query_594051, "api-version", newJString(apiVersion))
  add(path_594050, "subscriptionId", newJString(subscriptionId))
  add(path_594050, "accountName", newJString(accountName))
  result = call_594049.call(path_594050, query_594051, nil, nil, nil)

var workspacesListByAccounts* = Call_WorkspacesListByAccounts_594041(
    name: "workspacesListByAccounts", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces",
    validator: validate_WorkspacesListByAccounts_594042, base: "",
    url: url_WorkspacesListByAccounts_594043, schemes: {Scheme.Https})
type
  Call_WorkspacesCreateOrUpdate_594064 = ref object of OpenApiRestCall_593425
proc url_WorkspacesCreateOrUpdate_594066(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesCreateOrUpdate_594065(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594067 = path.getOrDefault("resourceGroupName")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = nil)
  if valid_594067 != nil:
    section.add "resourceGroupName", valid_594067
  var valid_594068 = path.getOrDefault("subscriptionId")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "subscriptionId", valid_594068
  var valid_594069 = path.getOrDefault("workspaceName")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "workspaceName", valid_594069
  var valid_594070 = path.getOrDefault("accountName")
  valid_594070 = validateParameter(valid_594070, JString, required = true,
                                 default = nil)
  if valid_594070 != nil:
    section.add "accountName", valid_594070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594071 = query.getOrDefault("api-version")
  valid_594071 = validateParameter(valid_594071, JString, required = true,
                                 default = nil)
  if valid_594071 != nil:
    section.add "api-version", valid_594071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594073: Call_WorkspacesCreateOrUpdate_594064; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_594073.validator(path, query, header, formData, body)
  let scheme = call_594073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594073.url(scheme.get, call_594073.host, call_594073.base,
                         call_594073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594073, url, valid)

proc call*(call_594074: Call_WorkspacesCreateOrUpdate_594064;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          parameters: JsonNode; workspaceName: string; accountName: string): Recallable =
  ## workspacesCreateOrUpdate
  ## Creates or updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594075 = newJObject()
  var query_594076 = newJObject()
  var body_594077 = newJObject()
  add(path_594075, "resourceGroupName", newJString(resourceGroupName))
  add(query_594076, "api-version", newJString(apiVersion))
  add(path_594075, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594077 = parameters
  add(path_594075, "workspaceName", newJString(workspaceName))
  add(path_594075, "accountName", newJString(accountName))
  result = call_594074.call(path_594075, query_594076, nil, nil, body_594077)

var workspacesCreateOrUpdate* = Call_WorkspacesCreateOrUpdate_594064(
    name: "workspacesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}",
    validator: validate_WorkspacesCreateOrUpdate_594065, base: "",
    url: url_WorkspacesCreateOrUpdate_594066, schemes: {Scheme.Https})
type
  Call_WorkspacesGet_594052 = ref object of OpenApiRestCall_593425
proc url_WorkspacesGet_594054(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesGet_594053(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594055 = path.getOrDefault("resourceGroupName")
  valid_594055 = validateParameter(valid_594055, JString, required = true,
                                 default = nil)
  if valid_594055 != nil:
    section.add "resourceGroupName", valid_594055
  var valid_594056 = path.getOrDefault("subscriptionId")
  valid_594056 = validateParameter(valid_594056, JString, required = true,
                                 default = nil)
  if valid_594056 != nil:
    section.add "subscriptionId", valid_594056
  var valid_594057 = path.getOrDefault("workspaceName")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "workspaceName", valid_594057
  var valid_594058 = path.getOrDefault("accountName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "accountName", valid_594058
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_WorkspacesGet_594052; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning workspace.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_WorkspacesGet_594052; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string;
          accountName: string): Recallable =
  ## workspacesGet
  ## Gets the properties of the specified machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594062 = newJObject()
  var query_594063 = newJObject()
  add(path_594062, "resourceGroupName", newJString(resourceGroupName))
  add(query_594063, "api-version", newJString(apiVersion))
  add(path_594062, "subscriptionId", newJString(subscriptionId))
  add(path_594062, "workspaceName", newJString(workspaceName))
  add(path_594062, "accountName", newJString(accountName))
  result = call_594061.call(path_594062, query_594063, nil, nil, nil)

var workspacesGet* = Call_WorkspacesGet_594052(name: "workspacesGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}",
    validator: validate_WorkspacesGet_594053, base: "", url: url_WorkspacesGet_594054,
    schemes: {Scheme.Https})
type
  Call_WorkspacesUpdate_594090 = ref object of OpenApiRestCall_593425
proc url_WorkspacesUpdate_594092(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesUpdate_594091(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594093 = path.getOrDefault("resourceGroupName")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "resourceGroupName", valid_594093
  var valid_594094 = path.getOrDefault("subscriptionId")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "subscriptionId", valid_594094
  var valid_594095 = path.getOrDefault("workspaceName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "workspaceName", valid_594095
  var valid_594096 = path.getOrDefault("accountName")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "accountName", valid_594096
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594097 = query.getOrDefault("api-version")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "api-version", valid_594097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594099: Call_WorkspacesUpdate_594090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a machine learning workspace with the specified parameters.
  ## 
  let valid = call_594099.validator(path, query, header, formData, body)
  let scheme = call_594099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594099.url(scheme.get, call_594099.host, call_594099.base,
                         call_594099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594099, url, valid)

proc call*(call_594100: Call_WorkspacesUpdate_594090; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; parameters: JsonNode;
          workspaceName: string; accountName: string): Recallable =
  ## workspacesUpdate
  ## Updates a machine learning workspace with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning workspace.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594101 = newJObject()
  var query_594102 = newJObject()
  var body_594103 = newJObject()
  add(path_594101, "resourceGroupName", newJString(resourceGroupName))
  add(query_594102, "api-version", newJString(apiVersion))
  add(path_594101, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594103 = parameters
  add(path_594101, "workspaceName", newJString(workspaceName))
  add(path_594101, "accountName", newJString(accountName))
  result = call_594100.call(path_594101, query_594102, nil, nil, body_594103)

var workspacesUpdate* = Call_WorkspacesUpdate_594090(name: "workspacesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}",
    validator: validate_WorkspacesUpdate_594091, base: "",
    url: url_WorkspacesUpdate_594092, schemes: {Scheme.Https})
type
  Call_WorkspacesDelete_594078 = ref object of OpenApiRestCall_593425
proc url_WorkspacesDelete_594080(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesDelete_594079(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Deletes a machine learning workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594081 = path.getOrDefault("resourceGroupName")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "resourceGroupName", valid_594081
  var valid_594082 = path.getOrDefault("subscriptionId")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = nil)
  if valid_594082 != nil:
    section.add "subscriptionId", valid_594082
  var valid_594083 = path.getOrDefault("workspaceName")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "workspaceName", valid_594083
  var valid_594084 = path.getOrDefault("accountName")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "accountName", valid_594084
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594085 = query.getOrDefault("api-version")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "api-version", valid_594085
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594086: Call_WorkspacesDelete_594078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a machine learning workspace.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_WorkspacesDelete_594078; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; workspaceName: string;
          accountName: string): Recallable =
  ## workspacesDelete
  ## Deletes a machine learning workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(path_594088, "workspaceName", newJString(workspaceName))
  add(path_594088, "accountName", newJString(accountName))
  result = call_594087.call(path_594088, query_594089, nil, nil, nil)

var workspacesDelete* = Call_WorkspacesDelete_594078(name: "workspacesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}",
    validator: validate_WorkspacesDelete_594079, base: "",
    url: url_WorkspacesDelete_594080, schemes: {Scheme.Https})
type
  Call_ProjectsCreateOrUpdate_594117 = ref object of OpenApiRestCall_593425
proc url_ProjectsCreateOrUpdate_594119(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsCreateOrUpdate_594118(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a project with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: JString (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594120 = path.getOrDefault("resourceGroupName")
  valid_594120 = validateParameter(valid_594120, JString, required = true,
                                 default = nil)
  if valid_594120 != nil:
    section.add "resourceGroupName", valid_594120
  var valid_594121 = path.getOrDefault("subscriptionId")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "subscriptionId", valid_594121
  var valid_594122 = path.getOrDefault("projectName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "projectName", valid_594122
  var valid_594123 = path.getOrDefault("workspaceName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "workspaceName", valid_594123
  var valid_594124 = path.getOrDefault("accountName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "accountName", valid_594124
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594125 = query.getOrDefault("api-version")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "api-version", valid_594125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a project.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594127: Call_ProjectsCreateOrUpdate_594117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a project with the specified parameters.
  ## 
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_ProjectsCreateOrUpdate_594117;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          projectName: string; parameters: JsonNode; workspaceName: string;
          accountName: string): Recallable =
  ## projectsCreateOrUpdate
  ## Creates or updates a project with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: string (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   parameters: JObject (required)
  ##             : The parameters for creating or updating a project.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  var body_594131 = newJObject()
  add(path_594129, "resourceGroupName", newJString(resourceGroupName))
  add(query_594130, "api-version", newJString(apiVersion))
  add(path_594129, "subscriptionId", newJString(subscriptionId))
  add(path_594129, "projectName", newJString(projectName))
  if parameters != nil:
    body_594131 = parameters
  add(path_594129, "workspaceName", newJString(workspaceName))
  add(path_594129, "accountName", newJString(accountName))
  result = call_594128.call(path_594129, query_594130, nil, nil, body_594131)

var projectsCreateOrUpdate* = Call_ProjectsCreateOrUpdate_594117(
    name: "projectsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}",
    validator: validate_ProjectsCreateOrUpdate_594118, base: "",
    url: url_ProjectsCreateOrUpdate_594119, schemes: {Scheme.Https})
type
  Call_ProjectsGet_594104 = ref object of OpenApiRestCall_593425
proc url_ProjectsGet_594106(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsGet_594105(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the properties of the specified machine learning project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: JString (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594107 = path.getOrDefault("resourceGroupName")
  valid_594107 = validateParameter(valid_594107, JString, required = true,
                                 default = nil)
  if valid_594107 != nil:
    section.add "resourceGroupName", valid_594107
  var valid_594108 = path.getOrDefault("subscriptionId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "subscriptionId", valid_594108
  var valid_594109 = path.getOrDefault("projectName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "projectName", valid_594109
  var valid_594110 = path.getOrDefault("workspaceName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "workspaceName", valid_594110
  var valid_594111 = path.getOrDefault("accountName")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "accountName", valid_594111
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594112 = query.getOrDefault("api-version")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "api-version", valid_594112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594113: Call_ProjectsGet_594104; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the properties of the specified machine learning project.
  ## 
  let valid = call_594113.validator(path, query, header, formData, body)
  let scheme = call_594113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594113.url(scheme.get, call_594113.host, call_594113.base,
                         call_594113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594113, url, valid)

proc call*(call_594114: Call_ProjectsGet_594104; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          workspaceName: string; accountName: string): Recallable =
  ## projectsGet
  ## Gets the properties of the specified machine learning project.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: string (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594115 = newJObject()
  var query_594116 = newJObject()
  add(path_594115, "resourceGroupName", newJString(resourceGroupName))
  add(query_594116, "api-version", newJString(apiVersion))
  add(path_594115, "subscriptionId", newJString(subscriptionId))
  add(path_594115, "projectName", newJString(projectName))
  add(path_594115, "workspaceName", newJString(workspaceName))
  add(path_594115, "accountName", newJString(accountName))
  result = call_594114.call(path_594115, query_594116, nil, nil, nil)

var projectsGet* = Call_ProjectsGet_594104(name: "projectsGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}",
                                        validator: validate_ProjectsGet_594105,
                                        base: "", url: url_ProjectsGet_594106,
                                        schemes: {Scheme.Https})
type
  Call_ProjectsUpdate_594145 = ref object of OpenApiRestCall_593425
proc url_ProjectsUpdate_594147(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsUpdate_594146(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates a project with the specified parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: JString (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594148 = path.getOrDefault("resourceGroupName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "resourceGroupName", valid_594148
  var valid_594149 = path.getOrDefault("subscriptionId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "subscriptionId", valid_594149
  var valid_594150 = path.getOrDefault("projectName")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = nil)
  if valid_594150 != nil:
    section.add "projectName", valid_594150
  var valid_594151 = path.getOrDefault("workspaceName")
  valid_594151 = validateParameter(valid_594151, JString, required = true,
                                 default = nil)
  if valid_594151 != nil:
    section.add "workspaceName", valid_594151
  var valid_594152 = path.getOrDefault("accountName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "accountName", valid_594152
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594153 = query.getOrDefault("api-version")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "api-version", valid_594153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning team account.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594155: Call_ProjectsUpdate_594145; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a project with the specified parameters.
  ## 
  let valid = call_594155.validator(path, query, header, formData, body)
  let scheme = call_594155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594155.url(scheme.get, call_594155.host, call_594155.base,
                         call_594155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594155, url, valid)

proc call*(call_594156: Call_ProjectsUpdate_594145; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          parameters: JsonNode; workspaceName: string; accountName: string): Recallable =
  ## projectsUpdate
  ## Updates a project with the specified parameters.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: string (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   parameters: JObject (required)
  ##             : The parameters for updating a machine learning team account.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594157 = newJObject()
  var query_594158 = newJObject()
  var body_594159 = newJObject()
  add(path_594157, "resourceGroupName", newJString(resourceGroupName))
  add(query_594158, "api-version", newJString(apiVersion))
  add(path_594157, "subscriptionId", newJString(subscriptionId))
  add(path_594157, "projectName", newJString(projectName))
  if parameters != nil:
    body_594159 = parameters
  add(path_594157, "workspaceName", newJString(workspaceName))
  add(path_594157, "accountName", newJString(accountName))
  result = call_594156.call(path_594157, query_594158, nil, nil, body_594159)

var projectsUpdate* = Call_ProjectsUpdate_594145(name: "projectsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}",
    validator: validate_ProjectsUpdate_594146, base: "", url: url_ProjectsUpdate_594147,
    schemes: {Scheme.Https})
type
  Call_ProjectsDelete_594132 = ref object of OpenApiRestCall_593425
proc url_ProjectsDelete_594134(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  assert "projectName" in path, "`projectName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces/"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsDelete_594133(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: JString (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594135 = path.getOrDefault("resourceGroupName")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "resourceGroupName", valid_594135
  var valid_594136 = path.getOrDefault("subscriptionId")
  valid_594136 = validateParameter(valid_594136, JString, required = true,
                                 default = nil)
  if valid_594136 != nil:
    section.add "subscriptionId", valid_594136
  var valid_594137 = path.getOrDefault("projectName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "projectName", valid_594137
  var valid_594138 = path.getOrDefault("workspaceName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "workspaceName", valid_594138
  var valid_594139 = path.getOrDefault("accountName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "accountName", valid_594139
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594140 = query.getOrDefault("api-version")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "api-version", valid_594140
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594141: Call_ProjectsDelete_594132; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a project.
  ## 
  let valid = call_594141.validator(path, query, header, formData, body)
  let scheme = call_594141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594141.url(scheme.get, call_594141.host, call_594141.base,
                         call_594141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594141, url, valid)

proc call*(call_594142: Call_ProjectsDelete_594132; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; projectName: string;
          workspaceName: string; accountName: string): Recallable =
  ## projectsDelete
  ## Deletes a project.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   projectName: string (required)
  ##              : The name of the machine learning project under a team account workspace.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594143 = newJObject()
  var query_594144 = newJObject()
  add(path_594143, "resourceGroupName", newJString(resourceGroupName))
  add(query_594144, "api-version", newJString(apiVersion))
  add(path_594143, "subscriptionId", newJString(subscriptionId))
  add(path_594143, "projectName", newJString(projectName))
  add(path_594143, "workspaceName", newJString(workspaceName))
  add(path_594143, "accountName", newJString(accountName))
  result = call_594142.call(path_594143, query_594144, nil, nil, nil)

var projectsDelete* = Call_ProjectsDelete_594132(name: "projectsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}",
    validator: validate_ProjectsDelete_594133, base: "", url: url_ProjectsDelete_594134,
    schemes: {Scheme.Https})
type
  Call_ProjectsListByWorkspace_594160 = ref object of OpenApiRestCall_593425
proc url_ProjectsListByWorkspace_594162(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "accountName" in path, "`accountName` is a required path parameter"
  assert "workspaceName" in path, "`workspaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MachineLearningExperimentation/accounts/"),
               (kind: VariableSegment, value: "accountName"),
               (kind: ConstantSegment, value: "/workspaces"),
               (kind: VariableSegment, value: "workspaceName"),
               (kind: ConstantSegment, value: "/projects")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProjectsListByWorkspace_594161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all the available machine learning projects under the specified workspace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   subscriptionId: JString (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: JString (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: JString (required)
  ##              : The name of the machine learning team account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594163 = path.getOrDefault("resourceGroupName")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "resourceGroupName", valid_594163
  var valid_594164 = path.getOrDefault("subscriptionId")
  valid_594164 = validateParameter(valid_594164, JString, required = true,
                                 default = nil)
  if valid_594164 != nil:
    section.add "subscriptionId", valid_594164
  var valid_594165 = path.getOrDefault("workspaceName")
  valid_594165 = validateParameter(valid_594165, JString, required = true,
                                 default = nil)
  if valid_594165 != nil:
    section.add "workspaceName", valid_594165
  var valid_594166 = path.getOrDefault("accountName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "accountName", valid_594166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594167 = query.getOrDefault("api-version")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "api-version", valid_594167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594168: Call_ProjectsListByWorkspace_594160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available machine learning projects under the specified workspace.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_ProjectsListByWorkspace_594160;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceName: string; accountName: string): Recallable =
  ## projectsListByWorkspace
  ## Lists all the available machine learning projects under the specified workspace.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group to which the machine learning team account belongs.
  ##   apiVersion: string (required)
  ##             : The client API version.
  ##   subscriptionId: string (required)
  ##                 : The Microsoft Azure subscription ID.
  ##   workspaceName: string (required)
  ##                : The name of the machine learning team account workspace.
  ##   accountName: string (required)
  ##              : The name of the machine learning team account.
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  add(path_594170, "resourceGroupName", newJString(resourceGroupName))
  add(query_594171, "api-version", newJString(apiVersion))
  add(path_594170, "subscriptionId", newJString(subscriptionId))
  add(path_594170, "workspaceName", newJString(workspaceName))
  add(path_594170, "accountName", newJString(accountName))
  result = call_594169.call(path_594170, query_594171, nil, nil, nil)

var projectsListByWorkspace* = Call_ProjectsListByWorkspace_594160(
    name: "projectsListByWorkspace", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces{workspaceName}/projects",
    validator: validate_ProjectsListByWorkspace_594161, base: "",
    url: url_ProjectsListByWorkspace_594162, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
